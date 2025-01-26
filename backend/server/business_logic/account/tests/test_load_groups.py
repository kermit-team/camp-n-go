import pytest
from django.conf import settings
from django.contrib.auth.models import Group
from django.test import TestCase, override_settings

from server.apps.account.exceptions.permission import PermissionNotExistsError
from server.business_logic.account import LoadGroupsBL, LoadPermissionsBL


class LoadGroupsBLTestCase(TestCase):
    PERMISSIONS = (
        {
            'NAME': 'Can do something with account',
            'CODENAME': 'do_something',
            'CONTENT_TYPE_MODEL': 'account',
            'CONTENT_TYPE_APP_LABEL': 'account',
        },
        {
            'NAME': 'Can do something else with account',
            'CODENAME': 'do_something_else',
            'CONTENT_TYPE_MODEL': 'account',
            'CONTENT_TYPE_APP_LABEL': 'account',
        },
    )
    GROUPS = (
        {
            'NAME': 'some-group',
            'PERMISSIONS': (PERMISSIONS[0]['CODENAME'],),
        },
    )

    @override_settings(GROUPS=GROUPS, PERMISSIONS=PERMISSIONS)
    def test_process_success(self):
        LoadPermissionsBL.process()
        LoadGroupsBL.process()

        for group_schema in settings.GROUPS:
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert set(group_schema['PERMISSIONS']) == {
                permission.codename for permission in group.permissions.all()
            }

    @override_settings(GROUPS=GROUPS, PERMISSIONS=PERMISSIONS)
    def test_process_when_group_already_exist_success(self):
        LoadPermissionsBL.process()
        LoadGroupsBL.process()
        LoadGroupsBL.process()

        for group_schema in settings.GROUPS:
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert set(group_schema['PERMISSIONS']) == {
                permission.codename for permission in group.permissions.all()
            }

    @override_settings(PERMISSIONS=PERMISSIONS)
    def test_process_when_group_permission_changed(self):
        original_permission = self.PERMISSIONS[0]['CODENAME']
        new_permission = self.PERMISSIONS[1]['CODENAME']

        LoadPermissionsBL.process()

        with override_settings(GROUPS=self.GROUPS):
            LoadGroupsBL.process()

            group_schema = settings.GROUPS[0]

            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert group.permissions.count() == 1
            assert group.permissions.first().codename == original_permission

        updated_groups = tuple(self.GROUPS)
        updated_groups[0]['PERMISSIONS'] = (new_permission,)

        with override_settings(GROUPS=updated_groups):
            LoadGroupsBL.process()

            group_schema = settings.GROUPS[0]
            group = Group.objects.filter(
                name=group_schema['NAME'],
            ).first()
            assert group

            assert group.permissions.count() == 1
            assert group.permissions.first().codename == new_permission

    @override_settings(GROUPS=GROUPS, PERMISSIONS=PERMISSIONS)
    def test_process_when_group_with_not_existing_permission(self):
        with pytest.raises(PermissionNotExistsError):
            LoadGroupsBL.process()
