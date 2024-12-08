from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.apps.car.exceptions.car import CarRegistrationPlateNotExistsError
from server.apps.car.models import Car
from server.business_logic.car import CarRemoveDriverBL
from server.datastore.commands.car import CarCommand
from server.datastore.queries.car import CarQuery


class CarRemoveDriverBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.car = baker.make(_model=Car)

    @mock.patch.object(CarCommand, 'remove_driver')
    @mock.patch.object(CarQuery, 'get_by_registration_plate')
    def test_process(self, get_car_by_registration_plate_mock, remove_driver_from_car_mock):
        get_car_by_registration_plate_mock.return_value = self.car

        CarRemoveDriverBL.process(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )

        get_car_by_registration_plate_mock.assert_called_once_with(registration_plate=self.car.registration_plate)
        remove_driver_from_car_mock.assert_called_once_with(car=self.car, driver=self.account)

    @mock.patch.object(CarCommand, 'remove_driver')
    @mock.patch.object(CarQuery, 'get_by_registration_plate')
    def test_process_for_not_existing_car(self, get_car_by_registration_plate_mock, remove_driver_from_car_mock):
        registration_plate = 'not_existing_registration_plate'

        get_car_by_registration_plate_mock.side_effect = Car.DoesNotExist()

        with self.assertRaises(CarRegistrationPlateNotExistsError):
            CarRemoveDriverBL.process(
                registration_plate=registration_plate,
                driver=self.account,
            )

        get_car_by_registration_plate_mock.assert_called_once_with(registration_plate=registration_plate)
        remove_driver_from_car_mock.assert_not_called()
