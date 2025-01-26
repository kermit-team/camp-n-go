from unittest import mock

import pytest
from django.core.management import CommandError, call_command
from django.test import TestCase

from server.apps.account.errors.permission import PermissionErrorMessagesEnum
from server.apps.account.exceptions.permission import PermissionNotExistsError
from server.business_logic.account import LoadGroupsBL


class LoadGroupsCommandTestCase(TestCase):
    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(LoadGroupsBL, 'process')
    def test_load_groups_success(self, load_groups_process_mock):
        call_command('load_groups')
        captured = self.capsys.readouterr()

        load_groups_process_mock.assert_called_once()
        assert captured.out == 'Successfully added groups.\n'

    @mock.patch.object(LoadGroupsBL, 'process')
    def test_load_groups_when_permission_not_exist(self, load_groups_process_mock):
        missing_permission_codename = 'missing_permission_codename'
        load_groups_process_mock.side_effect = PermissionNotExistsError(codename=missing_permission_codename)

        with pytest.raises(
            CommandError,
            match=PermissionErrorMessagesEnum.NOT_EXISTS.value.format(codename=missing_permission_codename),
        ):
            call_command('load_groups')
