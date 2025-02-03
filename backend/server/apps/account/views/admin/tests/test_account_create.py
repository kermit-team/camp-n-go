from unittest import mock

from django.contrib.auth.models import Group
from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views.admin import AdminAccountCreateView
from server.business_logic.account import AccountCreateBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin
from server.utils.tests.baker_generators import generate_password


class AdminAccountCreateViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminAccountCreateView
        cls.viewname = 'admin_account_create'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
        )

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.new_account = baker.prepare(_model=Account, is_superuser=True, _fill_optional=True)
        self.new_account_profile = baker.prepare(_model=AccountProfile, _fill_optional=True)
        self.groups = baker.make(_model=Group, _quantity=2)

    @mock.patch.object(AccountCreateBL, 'process')
    def test_request(self, create_account_mock):
        request_data = {
            'email': self.new_account.email,
            'password': self.password,
            'groups': [group.id for group in self.groups],
            'profile': {
                'first_name': self.new_account_profile.first_name,
                'last_name': self.new_account_profile.last_name,
            },
        }
        url = reverse(self.viewname)

        req = self.factory.post(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'email': str(create_account_mock.return_value.email),
            'groups': [],
            'profile': {
                'first_name': str(create_account_mock.return_value.profile.first_name),
                'last_name': str(create_account_mock.return_value.profile.last_name),
                'phone_number': str(create_account_mock.return_value.profile.phone_number),
                'avatar': create_account_mock.return_value.profile.avatar.url,
                'id_card': str(create_account_mock.return_value.profile.id_card),
            },
        }

        create_account_mock.assert_called_once_with(
            email=self.new_account.email,
            password=self.password,
            groups=self.groups,
            first_name=self.new_account_profile.first_name,
            last_name=self.new_account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )

        assert res.status_code == status.HTTP_201_CREATED
        assert res.data == expected_data

    @mock.patch.object(AccountCreateBL, 'process')
    def test_permissions(self, create_account_mock):
        request_data = {
            'email': self.new_account.email,
            'password': self.password,
            'groups': [group.id for group in self.groups],
            'profile': {
                'first_name': self.new_account_profile.first_name,
                'last_name': self.new_account_profile.last_name,
            },
        }

        self._create_accounts_with_groups_and_permissions()
        self._test_create_permissions(data=request_data)
