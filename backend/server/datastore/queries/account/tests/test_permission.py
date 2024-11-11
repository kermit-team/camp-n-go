from django.contrib.auth.models import Permission
from django.test import TestCase
from model_bakery import baker

from server.datastore.queries.account import PermissionQuery


class PermissionQueryTestCase(TestCase):
    def setUp(self):
        self.permission = baker.make(_model=Permission)

    def test_get_by_codename(self):
        codename = self.permission.codename

        permission = PermissionQuery.get_by_codename(codename=codename)

        assert permission

    def test_get_by_codename_without_existing_permission(self):
        codename = 'not_existing_permission'

        with self.assertRaises(Permission.DoesNotExist):
            PermissionQuery.get_by_codename(codename=codename)
