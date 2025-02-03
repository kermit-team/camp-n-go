from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.car.models import Car
from server.apps.car.views import CarEntryView
from server.datastore.queries.car import CarQuery
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class CarEntryViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarEntryView
        cls.viewname = 'car_entry'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

    def setUp(self):
        self.car = baker.make(_model=Car)

    @mock.patch.object(CarQuery, 'is_car_able_to_enter')
    def test_request(self, is_car_able_to_enter_mock):
        request_data = {'registration_plate': self.car.registration_plate}
        url = reverse(self.viewname)
        expected_data = {
            'message': is_car_able_to_enter_mock.return_value,
        }

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        is_car_able_to_enter_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CarQuery, 'is_car_able_to_enter')
    def test_permissions(self, is_car_able_to_enter_mock):
        self._create_accounts_with_groups_and_permissions()
        request_data = {'registration_plate': self.car.registration_plate}

        self._test_custom_view_permissions(
            request_factory_handler=self.factory.post,
            data=request_data,
        )
