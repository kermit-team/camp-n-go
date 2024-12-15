from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.managers import AccountManager
from server.apps.account.models import Account, AccountProfile
from server.utils.tests.baker_generators import generate_password


class AccountManagerTestCase(TestCase):

    def setUp(self):
        self.password = generate_password()
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    def test_create_account(self):
        account = Account.objects.create_account(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_superuser=self.account.is_superuser,
            is_active=self.account.is_active,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        assert account.email == self.account.email
        assert account.check_password(raw_password=self.password)
        assert account.is_superuser == self.account.is_superuser
        assert account.is_active == self.account.is_active
        assert account.profile.first_name == self.account_profile.first_name
        assert account.profile.last_name == self.account_profile.last_name
        assert account.profile.phone_number == self.account_profile.phone_number
        assert account.profile.avatar == self.account_profile.avatar
        assert account.profile.id_card == self.account_profile.id_card
        assert not account.groups.exists()

    @mock.patch.object(AccountManager, '_create_account_profile')
    def test_create_account_failed(self, create_account_profile_mock):
        exception_message = 'Some exception message'
        create_account_profile_mock.side_effect = ValueError(exception_message)

        with self.assertRaises(ValueError, msg=exception_message):
            Account.objects.create_account(
                email=self.account.email,
                password=self.password,
                first_name=self.account_profile.first_name,
                last_name=self.account_profile.last_name,
                is_superuser=self.account.is_superuser,
                is_active=self.account.is_active,
                phone_number=self.account_profile.phone_number,
                avatar=self.account_profile.avatar,
                id_card=self.account_profile.id_card,
            )

        assert not Account.objects.filter(email=self.account.email).exists()
        assert not AccountProfile.objects.filter(account__email=self.account.email).exists()

    def test_create_superuser_account(self):
        account = Account.objects.create_superuser_account(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_active=self.account.is_active,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        assert account.email == self.account.email
        assert account.check_password(raw_password=self.password)
        assert account.is_superuser is True
        assert account.is_active == self.account.is_active
        assert account.profile.first_name == self.account_profile.first_name
        assert account.profile.last_name == self.account_profile.last_name
        assert account.profile.phone_number == self.account_profile.phone_number
        assert account.profile.avatar == self.account_profile.avatar
        assert account.profile.id_card == self.account_profile.id_card
        assert not account.groups.exists()

    @mock.patch.object(AccountManager, '_create_account_profile')
    def test_create_superuser_account_failed(self, create_account_profile_mock):
        exception_message = 'Some exception message'
        create_account_profile_mock.side_effect = ValueError(exception_message)

        with self.assertRaises(ValueError, msg=exception_message):
            Account.objects.create_superuser_account(
                email=self.account.email,
                password=self.password,
                first_name=self.account_profile.first_name,
                last_name=self.account_profile.last_name,
                is_active=self.account.is_active,
                phone_number=self.account_profile.phone_number,
                avatar=self.account_profile.avatar,
                id_card=self.account_profile.id_card,
            )

        assert not Account.objects.filter(email=self.account.email).exists()
        assert not AccountProfile.objects.filter(account__email=self.account.email).exists()
