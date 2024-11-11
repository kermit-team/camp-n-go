import pytest
from django.conf import settings
from django.contrib.auth.models import Group
from django.core.management import CommandError, call_command
from django.test import TestCase, override_settings

from server.apps.account.errors.permission import PermissionErrorMessagesEnum
from server.business_logic.account.load_permissions import LoadPermissionsBL


class LoadGroupsCommandTestCase(TestCase):
    GROUPS = (
        {
            'NAME': 'some-group',
            'PERMISSIONS': (
                'some_permission',
            ),
        },
    )

    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    def test_create_groups_success(self):
        LoadPermissionsBL.process()
        call_command('load_groups')
        captured = self.capsys.readouterr()

        assert captured.out == 'Successfully added groups.\n'

        for group_schema in settings.GROUPS:
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert set(group_schema['PERMISSIONS']) == {
                permission.codename for permission in group.permissions.all()
            }

    def test_create_groups_already_exist_success(self):
        LoadPermissionsBL.process()
        call_command('load_groups')
        self.capsys.readouterr()
        call_command('load_groups')
        captured = self.capsys.readouterr()

        assert captured.out == 'Successfully added groups.\n'

        for group_schema in settings.GROUPS:
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert set(group_schema['PERMISSIONS']) == {
                permission.codename for permission in group.permissions.all()
            }

    def test_create_groups_permission_removed(self):
        original_permission = 'add_account'
        groups = (
            {
                'NAME': 'some-group',
                'PERMISSIONS': (
                    original_permission,
                ),
            },
        )

        LoadPermissionsBL.process()

        with override_settings(GROUPS=groups):
            call_command('load_groups')

            group_schema = settings.GROUPS[0]

            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert group.permissions.count() == 1
            assert group.permissions.first().codename == original_permission

        another_permission_codename = 'view_account'

        updated_groups = (
            {
                'NAME': 'some-group',
                'PERMISSIONS': (
                    another_permission_codename,
                ),
            },
        )

        with override_settings(GROUPS=updated_groups):
            call_command('load_groups')

            group_schema = settings.GROUPS[0]
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert group.permissions.count() == 1
            assert group.permissions.first().codename == another_permission_codename

    @override_settings(GROUPS=GROUPS)
    def test_create_groups_with_nonexistent_permission(self):
        with pytest.raises(
            CommandError,
            match=PermissionErrorMessagesEnum.NOT_EXISTS.value.format(
                codename=self.GROUPS[0]['PERMISSIONS'][0],
            ),
        ):
            call_command('load_groups')
