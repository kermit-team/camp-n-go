from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views import AccountRegisterView
from server.business_logic.account import AccountCreateBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin
from server.utils.tests.baker_generators import generate_password


class AccountRegisterViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountRegisterView
        cls.viewname = 'account_register'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

    def setUp(self):
        self.password = generate_password()
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountCreateBL, 'process')
    def test_request(self, create_account_mock):
        request_data = {
            'email': self.account.email,
            'password': self.password,
            'profile': {
                'first_name': self.account_profile.first_name,
                'last_name': self.account_profile.last_name,
            },
        }
        url = reverse(self.viewname)

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        expected_data = {
            'email': str(create_account_mock.return_value.email),
            'profile': {
                'first_name': str(create_account_mock.return_value.profile.first_name),
                'last_name': str(create_account_mock.return_value.profile.last_name),
                'phone_number': str(create_account_mock.return_value.profile.phone_number),
                'avatar': create_account_mock.return_value.profile.avatar.url,
                'id_card': str(create_account_mock.return_value.profile.id_card),
            },
        }

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )

        assert res.status_code == status.HTTP_201_CREATED
        assert res.data == expected_data

    @mock.patch.object(AccountCreateBL, 'process')
    def test_permissions(self, create_account_mock):
        self._create_accounts_with_groups_and_permissions()
        request_data = {
            'email': self.account.email,
            'password': self.password,
            'profile': {
                'first_name': self.account_profile.first_name,
                'last_name': self.account_profile.last_name,
            },
        }

        self._test_create_permissions(data=request_data)
