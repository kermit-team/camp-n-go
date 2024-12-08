from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account
from server.apps.car.messages.car import CarMessagesEnum
from server.apps.car.models import Car
from server.apps.car.views import CarRemoveDriverView
from server.datastore.commands.car import CarCommand


class CarRemoveDriverViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarRemoveDriverView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.car = baker.make(_model=Car)

    @mock.patch.object(CarCommand, 'remove_driver')
    def test_request(self, car_remove_driver_mock):
        parameters = {'registration_plate': self.car.registration_plate}
        url = reverse('car_remove_driver', kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {
            'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                driver_identifier=self.account.identifier,
                registration_plate=parameters['registration_plate'],
            ),
        }

        car_remove_driver_mock.assert_called_once_with(
            car=self.car,
            driver=self.account,
        )
        assert res.status_code == status.HTTP_204_NO_CONTENT
        assert res.data == expected_data

    @mock.patch.object(CarCommand, 'remove_driver')
    def test_request_without_existing_car(self, car_remove_driver_mock):
        parameters = {'registration_plate': 'not_existing_registration_plate'}
        url = reverse('car_remove_driver', kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        car_remove_driver_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
