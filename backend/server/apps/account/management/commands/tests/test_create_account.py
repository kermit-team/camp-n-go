from unittest import mock

import pytest
from django.conf import settings
from django.core.management import CommandError, call_command
from django.test import TestCase
from model_bakery import baker

from server.apps.account.errors.group import GroupErrorMessagesEnum
from server.apps.account.exceptions.group import GroupNotExistsError
from server.apps.account.models import Account, AccountProfile
from server.datastore.commands.account import AccountCommand


class CreateAccountCommandTestCase(TestCase):
    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(AccountCommand, 'create')
    def test_create_account_command_success(self, create_account_mock):
        group_names = [settings.OWNER]
        expected_message = 'Successfully created account with identifier: {identifier}.\n'.format(
            identifier=self.account.identifier,
        )

        create_account_mock.return_value = self.account

        call_command(
            'create_account',
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
            '--group_names',
            group_names,
            '--is_active',
        )
        captured = self.capsys.readouterr()

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            id_card=self.account_profile.id_card,
            is_active=True,
            group_names=group_names,
        )
        assert captured.out == expected_message

    @mock.patch.object(AccountCommand, 'create')
    def test_create_account_command_without_optional_arguments(self, create_account_mock):
        expected_message = 'Successfully created account with identifier: {identifier}.\n'.format(
            identifier=self.account.identifier,
        )

        create_account_mock.return_value = self.account

        call_command(
            'create_account',
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

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            group_names=[],
        )
        assert captured.out == expected_message

    @mock.patch.object(AccountCommand, 'create')
    def test_create_account_command_with_not_available_group(self, create_account_mock):
        group_names = ['not-existing-group']
        expected_message = "argument --group_names: invalid choice: '{group_name}'".format(group_name=group_names[0])

        with pytest.raises(CommandError, match=expected_message):
            call_command(
                'create_account',
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
                '--group_names',
                group_names,
                '--is_active',
            )

        create_account_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'create')
    def test_create_account_command_with_not_existing_group(self, create_account_mock):
        group_names = [settings.OWNER]

        create_account_mock.side_effect = GroupNotExistsError(name=group_names[0])

        with pytest.raises(
            CommandError,
            match=GroupErrorMessagesEnum.NOT_EXISTS.value.format(name=group_names[0]),
        ):
            call_command(
                'create_account',
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
                '--group_names',
                group_names,
                '--is_active',
            )

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            id_card=self.account_profile.id_card,
            is_active=True,
            group_names=group_names,
        )
