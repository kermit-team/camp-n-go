from django.test import TestCase
from model_bakery import baker

from server.apps.car.models import Car
from server.datastore.queries.car import CarQuery


class CarQueryTestCase(TestCase):
    def setUp(self):
        self.car = baker.make(_model=Car)

    def test_get_by_registration_plate(self):
        registration_plate = self.car.registration_plate

        car = CarQuery.get_by_registration_plate(registration_plate=registration_plate)

        assert car

    def test_get_by_registration_plate_without_existing_car(self):
        registration_plate = 'not_existing_registration_plate'

        with self.assertRaises(Car.DoesNotExist):
            CarQuery.get_by_registration_plate(registration_plate=registration_plate)
