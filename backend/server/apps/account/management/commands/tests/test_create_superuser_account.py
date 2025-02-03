from unittest import mock

import pytest
from django.core.management import call_command
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.datastore.commands.account import AccountCommand


class CreateSuperuserAccountCommandTestCase(TestCase):
    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(AccountCommand, 'create_superuser')
    def test_create_superuser_account_command_success(self, create_superuser_account_mock):
        expected_message = 'Successfully created superuser account with identifier: {identifier}.\n'.format(
            identifier=self.account.identifier,
        )

        create_superuser_account_mock.return_value = self.account

        call_command(
            'create_superuser_account',
            '--email',
            self.account.email,
            '--password',
            self.account.password,
            '--first_name',
            self.account_profile.first_name,
            '--last_name',
            self.account_profile.last_name,
            '--phone_number',
            self.account_profile.phone_number,
            '--id_card',
            self.account_profile.id_card,
            '--is_active',
        )
        captured = self.capsys.readouterr()

        create_superuser_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            id_card=self.account_profile.id_card,
            is_active=True,
        )
        assert captured.out == expected_message

    @mock.patch.object(AccountCommand, 'create_superuser')
    def test_create_superuser_account_command_without_optional_arguments(self, create_superuser_account_mock):
        expected_message = 'Successfully created superuser account with identifier: {identifier}.\n'.format(
            identifier=self.account.identifier,
        )

        create_superuser_account_mock.return_value = self.account

        call_command(
            'create_superuser_account',
            '--email',
            self.account.email,
            '--password',
            self.account.password,
            '--first_name',
            self.account_profile.first_name,
            '--last_name',
            self.account_profile.last_name,
        )
        captured = self.capsys.readouterr()

        create_superuser_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
        )
        assert captured.out == expected_message
