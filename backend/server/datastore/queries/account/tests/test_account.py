import uuid

from django.conf import settings
from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.datastore.queries.account import AccountQuery


class AccountQueryTestCase(TestCase):
    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True)

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

    def test_get_queryset_for_account_when_is_superuser(self):
        accounts = self._create_account_for_each_group()
        accounts.append(self.account)

        queryset = AccountQuery.get_queryset_for_account(account=self.account)

        self.assertCountEqual(queryset, accounts)

    def test_get_queryset_for_account(self):
        accounts = self._create_account_for_each_group()
        self.account.is_superuser = False

        queryset = AccountQuery.get_queryset_for_account(account=self.account)

        self.assertCountEqual(queryset, accounts)

    def test_get_with_matching_personal_data(self):
        Account.objects.all().delete()

        account_with_email = baker.make(
            _model=Account,
            email='abc123@gmail.com',
            profile__first_name='-',
            profile__last_name='-',
        )
        account_with_first_name = baker.make(
            _model=Account,
            email='def123@gmail.com',
            profile__first_name='abc',
            profile__last_name='-',
        )
        account_with_last_name = baker.make(
            _model=Account,
            email='ghi123@gmail.com',
            profile__first_name='-',
            profile__last_name='abc',
        )
        accounts = [account_with_email, account_with_first_name, account_with_last_name]

        queryset = AccountQuery.get_with_matching_personal_data(personal_data='abc')

        self.assertCountEqual(queryset, accounts)

    def _create_account_for_each_group(self):
        group_names = [group['NAME'] for group in settings.GROUPS]
        accounts = baker.make(_model=Account, _quantity=len(group_names))

        for index, group_name in enumerate(group_names):
            group, _ = Group.objects.get_or_create(name=group_name)
            accounts[index].groups.set([group])

        return accounts
