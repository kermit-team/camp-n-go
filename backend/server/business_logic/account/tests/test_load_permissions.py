from django.conf import settings
from django.contrib.auth.models import Permission
from django.test import TestCase, override_settings

from server.business_logic.account import LoadPermissionsBL


class LoadPermissionsBLTestCase(TestCase):
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

    @override_settings(PERMISSIONS=PERMISSIONS)
    def test_process_success(self):
        LoadPermissionsBL.process()

        for permission in settings.PERMISSIONS:
            assert Permission.objects.filter(
                name=permission['NAME'],
                codename=permission['CODENAME'],
                content_type__app_label=permission['CONTENT_TYPE_APP_LABEL'],
                content_type__model=permission['CONTENT_TYPE_MODEL'],
            ).exists()

    @override_settings(PERMISSIONS=PERMISSIONS)
    def test_process_when_permissions_already_exists_success(self):
        LoadPermissionsBL.process()
        LoadPermissionsBL.process()

        for permission in settings.PERMISSIONS:
            assert Permission.objects.filter(
                name=permission['NAME'],
                codename=permission['CODENAME'],
                content_type__app_label=permission['CONTENT_TYPE_APP_LABEL'],
                content_type__model=permission['CONTENT_TYPE_MODEL'],
            ).exists()
