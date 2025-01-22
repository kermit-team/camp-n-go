from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account
from server.apps.car.models import Car
from server.apps.car.views import CarEntryView
from server.datastore.queries.car import CarQuery


class CarEntryViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarEntryView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.car = baker.make(_model=Car)

    @mock.patch.object(CarQuery, 'is_car_able_to_enter')
    def test_request(self, is_car_able_to_enter_mock):
        request_data = {'registration_plate': self.car.registration_plate}
        url = reverse('car_entry')
        expected_data = {
            'message': is_car_able_to_enter_mock.return_value,
        }

        req = self.factory.post(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        is_car_able_to_enter_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data
