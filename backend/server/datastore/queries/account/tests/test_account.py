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

        account = AccountQuery.get_by_identifier(identifier=identifier)

        assert account

    def test_get_by_identifier_without_existing_account(self):
        identifier = uuid.uuid4()

        with self.assertRaises(Account.DoesNotExist):
            AccountQuery.get_by_identifier(identifier=identifier)

    def test_get_by_email(self):
        email = self.account.email

        account = AccountQuery.get_by_email(email=email)

        assert account

    def test_get_by_email_without_existing_account(self):
        email = 'not_existing_email'

        with self.assertRaises(Account.DoesNotExist):
            AccountQuery.get_by_email(email=email)
