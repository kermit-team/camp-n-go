import uuid
from unittest import mock

from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views.admin import AdminAccountModifyView
from server.datastore.commands.account import AccountCommand
from server.utils.tests.baker_generators import generate_password


class AdminAccountModifyViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminAccountModifyView

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(
            _model=Account,
            password=make_password(self.password),
            is_superuser=True,
            _fill_optional=True,
        )
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.groups = baker.make(_model=Group, _quantity=2)
        self.new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_put(self, modify_account_mock):
        request_data = {
            'groups': [group.id for group in self.groups],
            'is_active': False,
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': self.account.identifier,
        }
        url = reverse('admin_account_modify', kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_account_mock.return_value,
            context={'request': req},
        ).data

        modify_account_mock.assert_called_once_with(
            account=self.account,
            groups=self.groups,
            is_active=request_data['is_active'],
            first_name=request_data['profile']['first_name'],
            last_name=request_data['profile']['last_name'],
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(AccountCommand, 'modify')
    def test_request_put_without_existing_account(self, modify_account_mock):
        request_data = {
            'groups': [group.id for group in self.groups],
            'is_active': False,
            'profile': {
                'first_name': self.new_profile_data.first_name,
                'last_name': self.new_profile_data.last_name,
            },
        }
        parameters = {
            'identifier': uuid.uuid4(),
        }
        url = reverse('admin_account_modify', kwargs=parameters)

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
        url = reverse('admin_account_modify', kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_account_mock.return_value,
            context={'request': req},
        ).data

        modify_account_mock.assert_called_once_with(
            account=self.account,
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
        url = reverse('admin_account_modify', kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_account_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
