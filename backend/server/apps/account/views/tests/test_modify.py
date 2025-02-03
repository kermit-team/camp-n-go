import uuid
from unittest import mock

from django.contrib.auth.hashers import make_password
from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views import AccountModifyView
from server.datastore.commands.account import AccountCommand
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin
from server.utils.tests.baker_generators import generate_password


class AccountModifyViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountModifyView
        cls.viewname = 'account_modify'
        cls.view_permissions = AccountViewPermissions(
            superuser=False,
        )

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(
            _model=Account,
            password=make_password(self.password),
            is_superuser=True,
            _fill_optional=True,
        )
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_put(self, modify_account_mock):
        request_data = {
            'old_password': self.password,
            'new_password': generate_password(),
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': self.account.identifier,
        }
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_account_mock.return_value,
            context={'request': req},
        ).data

        modify_account_mock.assert_called_once_with(
            account=self.account,
            password=request_data['new_password'],
            first_name=request_data['profile']['first_name'],
            last_name=request_data['profile']['last_name'],
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_put_without_existing_account(self, modify_account_mock):
        request_data = {
            'old_password': self.password,
            'new_password': generate_password(),
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': uuid.uuid4(),
        }
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_account_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_patch(self, modify_account_mock):
        request_data = {
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': self.account.identifier,
        }
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_account_mock.return_value,
            context={'request': req},
        ).data

        modify_account_mock.assert_called_once_with(
            account=self.account,
            password=None,
            first_name=request_data['profile']['first_name'],
            last_name=request_data['profile']['last_name'],
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_patch_without_existing_account(self, modify_account_mock):
        request_data = {
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': uuid.uuid4(),
        }
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_account_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(AccountCommand, 'modify')
    def test_permissions(self, modify_account_mock):
        self._create_accounts_with_groups_and_permissions()
        put_request_data = {
            'old_password': self.accounts_password,
            'new_password': generate_password(),
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        patch_request_data = {
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }

        account = baker.make(_model=Account, password=make_password(self.accounts_password))
        parameters = {'identifier': account.identifier}
        self._test_update_permissions(parameters=parameters, data=put_request_data)
        self._test_partial_update_permissions(parameters=parameters, data=patch_request_data)

    @mock.patch.object(AccountCommand, 'modify')
    def test_permissions_as_object_relation(self, modify_account_mock):
        self._create_accounts_with_groups_and_permissions()

        default_account = baker.make(_model=Account, password=make_password(self.accounts_password))
        put_request_data = {
            'old_password': self.accounts_password,
            'new_password': generate_password(),
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        patch_request_data = {
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
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

            request = self.factory.put(url, data=put_request_data)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )

            request = self.factory.patch(url, data=patch_request_data)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
