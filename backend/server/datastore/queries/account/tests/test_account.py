import uuid

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.datastore.queries.account import AccountQuery


class AccountQueryTestCase(TestCase):
    def setUp(self):
        self.account = baker.make(_model=Account)

    def test_get_by_identifier(self):
        identifier = self.account.identifier

        group = AccountQuery.get_by_identifier(identifier=identifier)

        assert group

    def test_get_by_identifier_without_existing_account(self):
        identifier = uuid.uuid4()

        with self.assertRaises(Account.DoesNotExist):
            AccountQuery.get_by_identifier(identifier=identifier)
