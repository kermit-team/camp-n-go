from unittest import mock

import pytest
from django.core.management import call_command
from django.test import TestCase

from server.business_logic.account import LoadPermissionsBL


class LoadPermissionsCommandTestCase(TestCase):
    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(LoadPermissionsBL, 'process')
    def test_load_permissions_success(self, load_permissions_process_mock):
        call_command('load_permissions')
        captured = self.capsys.readouterr()

        load_permissions_process_mock.assert_called_once()
        assert captured.out == 'Successfully added permissions.\n'
