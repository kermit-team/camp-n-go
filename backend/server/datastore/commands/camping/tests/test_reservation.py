from datetime import date
from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection, PaymentStatus, Reservation
from server.apps.car.models import Car
from server.business_logic.camping.stripe_payment import StripePaymentCreateCheckoutBL
from server.datastore.commands.camping.reservation import ReservationCommand
from server.datastore.queries.camping import ReservationQuery
from server.utils.tests.baker_generators import generate_password


class ReservationCommandTestCase(TestCase):
    given_date = date(2020, 1, 1)

    number_of_adults = 2
    number_of_children = 1

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    @mock.patch.object(StripePaymentCreateCheckoutBL, 'process')
    def test_create(self, stripe_payment_create_checkout_mock):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)
        comments = 'Some comments'

        stripe_payment_create_checkout_mock.return_value = mock.MagicMock(id='stripe_checkout_id')

        reservation = ReservationCommand.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=comments,
        )

        stripe_payment_create_checkout_mock.assert_called_once_with(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            camping_plot=self.camping_plot,
        )

        assert reservation.date_from == date_from
        assert reservation.date_to == date_to
        assert reservation.number_of_adults == self.number_of_adults
        assert reservation.number_of_children == self.number_of_children
        assert reservation.comments == comments
        assert reservation.user == self.account
        assert reservation.car == self.car
        assert reservation.camping_plot == self.camping_plot

        assert reservation.payment
        assert reservation.payment.stripe_checkout_id == stripe_payment_create_checkout_mock.return_value.id
        assert reservation.payment.price == ReservationQuery.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )
        assert reservation.payment.status == PaymentStatus.WAITING_FOR_PAYMENT

    @mock.patch.object(StripePaymentCreateCheckoutBL, 'process')
    def test_create_without_optional_fields(self, stripe_payment_create_checkout_mock):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        stripe_payment_create_checkout_mock.return_value = mock.MagicMock(id='stripe_checkout_id')

        reservation = ReservationCommand.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
        )

        stripe_payment_create_checkout_mock.assert_called_once_with(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            camping_plot=self.camping_plot,
        )

        assert reservation.date_from == date_from
        assert reservation.date_to == date_to
        assert reservation.number_of_adults == self.number_of_adults
        assert reservation.number_of_children == self.number_of_children
        assert reservation.comments is None
        assert reservation.user == self.account
        assert reservation.car == self.car
        assert reservation.camping_plot == self.camping_plot

        assert reservation.payment
        assert reservation.payment.stripe_checkout_id == stripe_payment_create_checkout_mock.return_value.id
        assert reservation.payment.price == ReservationQuery.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )
        assert reservation.payment.status == PaymentStatus.WAITING_FOR_PAYMENT

    def test_modify(self):
        reservation = baker.make(_model=Reservation, car=self.car, _fill_optional=True)
        new_car = baker.make(_model=Car)

        reservation = ReservationCommand.modify(reservation=reservation, car=new_car)

        assert reservation.car == new_car
