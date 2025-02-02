from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account
from server.apps.car.models import Car
from server.apps.car.views import CarAddView
from server.datastore.commands.car import CarCommand
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class CarAddViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarAddView
        cls.viewname = 'car_add'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
            client=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.car = baker.prepare(_model=Car)

    @mock.patch.object(CarCommand, 'add')
    def test_request(self, add_car_mock):
        add_car_mock.return_value = self.car
        request_data = {'registration_plate': self.car.registration_plate}
        url = reverse(self.viewname)

        req = self.factory.post(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'id': self.car.id,
            'registration_plate': self.car.registration_plate,
        }

        add_car_mock.assert_called_once_with(
            registration_plate=self.car.registration_plate,
            driver=self.account,
        )
        assert res.status_code == status.HTTP_201_CREATED
        assert res.data == expected_data

    @mock.patch.object(CarCommand, 'add')
    def test_permissions(self, add_car_mock):
        self._create_accounts_with_groups_and_permissions()
        add_car_mock.return_value = self.car
        request_data = {'registration_plate': self.car.registration_plate}

        self._test_create_permissions(data=request_data)
