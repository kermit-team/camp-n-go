import uuid

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views.account_details import AccountDetailsView
from server.apps.car.models import Car
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AccountDetailsViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountDetailsView
        cls.viewname = 'account_details'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.cars = baker.make(_model=Car, _quantity=2)
        for car in self.cars:
            car.drivers.add(self.account)

    def test_request(self):
        parameters = {'identifier': self.account.identifier}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=self.account,
            context={'request': req},
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_request_without_existing_account(self):
        parameters = {'identifier': uuid.uuid4()}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    def test_permissions(self):
        self._create_accounts_with_groups_and_permissions()
        account = baker.make(_model=Account)
        parameters = {'identifier': account.identifier}

        self._test_retrieve_permissions(parameters=parameters)

    def test_permissions_as_object_relation(self):
        self._create_accounts_with_groups_and_permissions()

        default_account = baker.make(_model=Account)
        accounts_with_view_permissions = (
            (None, False),
            (self._account, False),
            (self._owner, True),
            (self._employee, True),
            (self._client, True),
            (self._superuser, True),
        )

        for account, has_permissions in accounts_with_view_permissions:
            parameters = {'identifier': account.identifier if account else default_account.identifier}
            url = reverse(self.viewname, kwargs=parameters)

            request = self.factory.get(url)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
