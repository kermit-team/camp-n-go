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
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class CarRemoveDriverViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CarRemoveDriverView
        cls.viewname = 'car_remove_driver'
        cls.view_permissions = AccountViewPermissions(
            superuser=False,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.car = baker.make(_model=Car)
        self.car.drivers.add(self.account)

    @mock.patch.object(CarCommand, 'remove_driver')
    def test_request(self, car_remove_driver_mock):
        parameters = {'pk': self.car.id}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {
            'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                driver_identifier=self.account.identifier,
                registration_plate=self.car.registration_plate,
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
        parameters = {'pk': 0}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        car_remove_driver_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(CarCommand, 'remove_driver')
    def test_permissions(self, car_remove_driver_mock):
        self._create_accounts_with_groups_and_permissions()
        parameters = {'pk': self.car.id}

        self._test_destroy_permissions(parameters=parameters)

    @mock.patch.object(CarCommand, 'remove_driver')
    def test_permissions_as_object_relation(self, car_remove_driver_mock):
        self._create_accounts_with_groups_and_permissions()
        parameters = {'pk': self.car.id}

        accounts_with_view_permissions = (
            (None, False),
            (self._account, False),
            (self._owner, True),
            (self._employee, True),
            (self._client, True),
            (self._superuser, True),
        )

        for account, has_permissions in accounts_with_view_permissions:
            if account:
                self.car.drivers.set([account], clear=True)

            url = reverse(self.viewname, kwargs=parameters)

            request = self.factory.delete(url)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
