from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account
from server.apps.car.messages.car import CarMessagesEnum
from server.apps.car.models import Car
from server.apps.car.views import CarRemoveDriverView
from server.business_logic.car import CarRemoveDriverBL


class CarRemoveDriverViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarRemoveDriverView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.car = baker.make(_model=Car)

    @mock.patch.object(CarRemoveDriverBL, 'process')
    def test_request(self, car_remove_driver_mock):
        request_data = {'registration_plate': self.car.registration_plate}
        url = reverse('car_remove_driver')

        req = self.factory.post(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                driver_identifier=self.account.identifier,
                registration_plate=request_data['registration_plate'],
            ),
        }

        car_remove_driver_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )
        assert res.status_code == status.HTTP_204_NO_CONTENT
        assert res.data == expected_data
