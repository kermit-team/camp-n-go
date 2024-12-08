from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.apps.car.models import Car
from server.apps.car.serializers import CarAddSerializer
from server.datastore.commands.car import CarCommand


class CarAddSerializerTestCase(TestCase):

    def setUp(self):
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.car = baker.prepare(_model=Car)
        self.request = mock.MagicMock(user=self.account)

    @mock.patch.object(CarCommand, 'add')
    def test_create(self, add_car_mock):
        serializer = CarAddSerializer(
            data={'registration_plate': self.car.registration_plate},
            context={'request': self.request},
        )

        assert serializer.is_valid(raise_exception=True)
        serializer.save()

        add_car_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )

    @mock.patch.object(CarCommand, 'add')
    def test_create_when_registration_plate_exists(self, add_car_mock):
        self.car.save()

        serializer = CarAddSerializer(
            data={'registration_plate': self.car.registration_plate},
            context={'request': self.request},
        )

        assert serializer.is_valid(raise_exception=True)
        serializer.save()

        add_car_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )
