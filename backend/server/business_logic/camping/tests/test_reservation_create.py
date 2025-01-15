from datetime import date, timedelta
from unittest import mock

from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.exceptions.reservation import (
    AdultMissingForReservationError,
    CampingPlotNotAvailableForReservationError,
    CarNotBelongsToAccountError,
    IdCardMissingForReservationError,
    TooManyPeopleForReservationError,
)
from server.apps.camping.models import CampingPlot, CampingSection
from server.apps.car.models import Car
from server.apps.common.exceptions.common import DateInThePastError, InvalidDateValuesError
from server.business_logic.camping import ReservationCreateBL
from server.datastore.commands.camping.reservation import ReservationCommand
from server.datastore.queries.camping import CampingPlotQuery
from server.utils.tests.baker_generators import generate_password


class ReservationCreateBLTestCase(TestCase):
    given_date = date(2020, 1, 1)
    date_from = given_date + timedelta(days=7)
    date_to = date_from + timedelta(days=7)

    number_of_adults = 2
    number_of_children = 1

    comments = 'Some comments'

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.car.drivers.add(self.account)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            max_number_of_people=self.number_of_adults + self.number_of_children,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        result = ReservationCreateBL.process(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=self.comments,
        )

        create_reservation_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=self.comments,
        )
        assert result == create_reservation_mock.return_value

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_without_optional_fields(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        result = ReservationCreateBL.process(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
        )

        create_reservation_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=None,
        )
        assert result == create_reservation_mock.return_value

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_with_invalid_dates(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        with self.assertRaises(InvalidDateValuesError):
            ReservationCreateBL.process(
                date_from=self.date_to,
                date_to=self.date_from,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_with_date_in_the_past(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        with self.assertRaises(DateInThePastError):
            ReservationCreateBL.process(
                date_from=self.given_date,
                date_to=self.date_to,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_without_account_id_card(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True
        self.account_profile.id_card = None
        self.account_profile.save()

        with self.assertRaises(IdCardMissingForReservationError):
            ReservationCreateBL.process(
                date_from=self.date_from,
                date_to=self.date_to,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_when_car_not_belongs_to_account(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True
        self.car.drivers.clear()

        with self.assertRaises(CarNotBelongsToAccountError):
            ReservationCreateBL.process(
                date_from=self.date_from,
                date_to=self.date_to,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_with_missing_adult_person(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        with self.assertRaises(AdultMissingForReservationError):
            ReservationCreateBL.process(
                date_from=self.date_from,
                date_to=self.date_to,
                number_of_adults=0,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_with_too_many_people(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = True

        with self.assertRaises(TooManyPeopleForReservationError):
            ReservationCreateBL.process(
                date_from=self.date_from,
                date_to=self.date_to,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children + 1,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()

    @freeze_time(given_date)
    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(ReservationCommand, 'create')
    def test_process_with_not_available_camping_plot(self, create_reservation_mock, get_available_camping_plot_mock):
        get_available_camping_plot_mock.return_value.exists.return_value = False

        with self.assertRaises(CampingPlotNotAvailableForReservationError):
            ReservationCreateBL.process(
                date_from=self.date_from,
                date_to=self.date_to,
                number_of_adults=self.number_of_adults,
                number_of_children=self.number_of_children,
                user=self.account,
                car=self.car,
                camping_plot=self.camping_plot,
            )

        create_reservation_mock.assert_not_called()
