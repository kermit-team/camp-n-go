from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.datastore.queries.account import GroupQuery


class GroupQueryTestCase(TestCase):
    def setUp(self):
        self.group = baker.make(_model=Group)

    def test_get_by_name(self):
        name = self.group.name

        group = GroupQuery.get_by_name(name=name)

        assert group

    def test_get_by_name_without_existing_group(self):
        name = 'not_existing_group'

        with self.assertRaises(Group.DoesNotExist):
            GroupQuery.get_by_name(name=name)

    def test_get_queryset(self):
        queryset = GroupQuery.get_queryset()

        assert queryset.count() == 1
        assert self.group in queryset
