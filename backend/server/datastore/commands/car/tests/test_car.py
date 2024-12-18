from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.apps.car.models import Car
from server.datastore.commands.car import CarCommand


class CarCommandTestCase(TestCase):
    def setUp(self):
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.car = baker.prepare(_model=Car)

    def test_add_car(self):
        car = CarCommand.add(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )

        assert car
        assert car.drivers.filter(identifier=self.account.identifier).exists()

    def test_add_car_when_registration_plate_exists(self):
        self.car.save()

        car = CarCommand.add(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )

        assert car
        assert self.car.drivers.filter(identifier=self.account.identifier).exists()

    def test_remove_driver_from_car(self):
        self.car.save()

        car = CarCommand.remove_driver(
            car=self.car,
            driver=self.account,
        )

        assert car
        assert not car.drivers.filter(identifier=self.account.identifier).exists()
