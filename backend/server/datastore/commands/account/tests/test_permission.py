from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.test import TestCase
from model_bakery import baker

from server.datastore.commands.account import PermissionCommand


class PermissionCommandTestCase(TestCase):
    def setUp(self):
        self.content_type = baker.make(_model=ContentType)
        self.permission = baker.make(_model=Permission, content_type=self.content_type)

    def test_get_or_create_when_content_type_and_permission_not_exists(self):
        name = 'new_permission_name'
        codename = 'new_permission_codename'
        content_type_model = 'new_content_type_model'
        content_type_app_label = 'new_content_type_app_label'

        permission, created = PermissionCommand.get_or_create(
            name=name,
            codename=codename,
            content_type_model=content_type_model,
            content_type_app_label=content_type_app_label,
        )

        assert permission.name == name
        assert permission.codename == codename
        assert permission.content_type.model == content_type_model
        assert permission.content_type.app_label == content_type_app_label
        assert created is True

    def test_get_or_create_when_content_type_not_exists_and_permission_exists(self):
        name = self.permission.name
        codename = self.permission.codename
        content_type_model = 'new_content_type_model'
        content_type_app_label = 'new_content_type_app_label'

        permission, created = PermissionCommand.get_or_create(
            name=name,
            codename=codename,
            content_type_model=content_type_model,
            content_type_app_label=content_type_app_label,
        )

        assert permission.name == name
        assert permission.codename == codename
        assert permission.content_type.model == content_type_model
        assert permission.content_type.app_label == content_type_app_label
        assert created is True

    def test_get_or_create_when_content_type_exists_and_permission_not_exists(self):
        name = 'new_permission_name'
        codename = 'new_permission_codename'
        content_type_model = self.content_type.model
        content_type_app_label = self.content_type.app_label

        permission, created = PermissionCommand.get_or_create(
            name=name,
            codename=codename,
            content_type_model=content_type_model,
            content_type_app_label=content_type_app_label,
        )

        assert permission.name == name
        assert permission.codename == codename
        assert permission.content_type.model == content_type_model
        assert permission.content_type.app_label == content_type_app_label
        assert created is True

    def test_get_or_create_when_content_type_and_permission_exists(self):
        name = self.permission.name
        codename = self.permission.codename
        content_type_model = self.content_type.model
        content_type_app_label = self.content_type.app_label

        permission, created = PermissionCommand.get_or_create(
            name=name,
            codename=codename,
            content_type_model=content_type_model,
            content_type_app_label=content_type_app_label,
        )

        assert permission.name == name
        assert permission.codename == codename
        assert permission.content_type.model == content_type_model
        assert permission.content_type.app_label == content_type_app_label
        assert created is False
