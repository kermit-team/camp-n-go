from datetime import date, timedelta
from unittest import mock

from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.exceptions.reservation import CarNotBelongsToAccountError, ReservationCarCannotBeModifiedError
from server.apps.camping.models import Reservation
from server.apps.car.models import Car
from server.business_logic.camping import ReservationModifyCarBL
from server.datastore.commands.camping.reservation import ReservationCommand
from server.datastore.queries.car import CarQuery
from server.utils.tests.baker_generators import generate_password


class ReservationModifyBLTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date_from + timedelta(days=7)

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.car.drivers.add(self.account)
        self.reservation = baker.make(
            _model=Reservation,
            date_from=self.date_from,
            date_to=self.date_to,
            user=self.account,
            car=self.car,
            _fill_optional=True,
        )
        self.new_car = baker.make(_model=Car, _fill_optional=True)
        self.new_car.drivers.add(self.account)

    @freeze_time(date_to)
    @mock.patch.object(ReservationCommand, 'modify')
    @mock.patch.object(CarQuery, 'car_belongs_to_user')
    def test_process(self, car_belongs_to_user_mock, modify_reservation_mock):
        car_belongs_to_user_mock.return_value = True

        result = ReservationModifyCarBL.process(reservation=self.reservation, car=self.new_car)

        car_belongs_to_user_mock.assert_called_once_with(car=self.new_car, user=self.account)
        modify_reservation_mock.assert_called_once_with(reservation=self.reservation, car=self.new_car)
        assert result == modify_reservation_mock.return_value

    @freeze_time(date_to)
    @mock.patch.object(ReservationCommand, 'modify')
    @mock.patch.object(CarQuery, 'car_belongs_to_user')
    def test_process_without_optional_fields(self, car_belongs_to_user_mock, modify_reservation_mock):
        result = ReservationModifyCarBL.process(reservation=self.reservation)

        car_belongs_to_user_mock.assert_not_called()
        modify_reservation_mock.assert_not_called()
        assert result == self.reservation

    @freeze_time(date_to + timedelta(days=1))
    @mock.patch.object(ReservationCommand, 'modify')
    @mock.patch.object(CarQuery, 'car_belongs_to_user')
    def test_process_when_reservation_is_in_past(self, car_belongs_to_user_mock, modify_reservation_mock):
        with self.assertRaises(ReservationCarCannotBeModifiedError):
            ReservationModifyCarBL.process(reservation=self.reservation, car=self.new_car)

        car_belongs_to_user_mock.assert_not_called()
        modify_reservation_mock.assert_not_called()

    @freeze_time(date_to)
    @mock.patch.object(ReservationCommand, 'modify')
    @mock.patch.object(CarQuery, 'car_belongs_to_user')
    def test_process_when_car_not_belongs_to_user(self, car_belongs_to_user_mock, modify_reservation_mock):
        car_belongs_to_user_mock.return_value = False

        with self.assertRaises(CarNotBelongsToAccountError):
            ReservationModifyCarBL.process(reservation=self.reservation, car=self.new_car)

        car_belongs_to_user_mock.assert_called_once_with(car=self.new_car, user=self.account)
        modify_reservation_mock.assert_not_called()
