import pytest
from django.conf import settings
from django.contrib.auth.models import Permission
from django.core.management import call_command
from django.test import TestCase


class LoadPermissionsCommandTestCase(TestCase):
    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    def test_load_permissions_success(self):
        call_command('load_permissions')
        captured = self.capsys.readouterr()

        assert captured.out == 'Successfully added permissions.\n'

        for permission in settings.PERMISSIONS:
            assert Permission.objects.filter(
                name=permission['NAME'],
                codename=permission['CODENAME'],
                content_type__app_label=permission['CONTENT_TYPE_APP_LABEL'],
                content_type__model=permission['CONTENT_TYPE_MODEL'],
            ).exists()
