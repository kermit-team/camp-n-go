from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.datastore.commands.account import GroupCommand


class GroupCommandTestCase(TestCase):
    def setUp(self):
        self.group = baker.make(_model=Group)

    def test_get_or_create_when_not_exists(self):
        name = 'new_group_name'

        group, created = GroupCommand.get_or_create(name=name)

        assert group.name == name
        assert created is True

    def test_get_or_create_when_exists(self):
        name = self.group.name

        group, created = GroupCommand.get_or_create(name=name)

        assert group.name == name
        assert created is False
