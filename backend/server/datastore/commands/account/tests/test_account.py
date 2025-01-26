import uuid
from unittest import mock

from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group, Permission
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.car.models import Car
from server.datastore.commands.account import AccountCommand
from server.utils.tests.baker_generators import generate_password


class AccountCommandTestCase(TestCase):
    mock_create_account_path = (
        'server.datastore.commands.account.account.Account.objects.create_account'
    )
    mock_create_superuser_account_path = (
        'server.datastore.commands.account.account.Account.objects.create_superuser_account'
    )

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(
            _model=Account,
            is_active=True,
            password=make_password(self.password),
            _fill_optional=True,
        )
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.group = baker.make(_model=Group)

    @mock.patch(mock_create_account_path)
    def test_create_account(self, create_account_mock):
        new_group = baker.make(_model=Group)
        groups = [
            self.group,
            new_group,
        ]

        create_account_mock.return_value = self.account

        account = AccountCommand.create(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_superuser=self.account.is_superuser,
            is_active=self.account.is_active,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            groups=groups,
        )

        create_account_mock.assert_called_once_with(
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

        assert account is not None
        self.assertCountEqual(account.groups.all(), groups)

    @mock.patch(mock_create_account_path)
    def test_create_account_without_optional_fields(self, create_account_mock):
        create_account_mock.return_value = self.account

        account = AccountCommand.create(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
        )

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
        )

        assert account is not None
        assert not account.groups.exists()

    @mock.patch(mock_create_superuser_account_path)
    def test_create_superuser_account(self, create_superuser_account_mock):
        create_superuser_account_mock.return_value = self.account

        account = AccountCommand.create_superuser(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_active=self.account.is_active,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        create_superuser_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_active=self.account.is_active,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        assert account is not None

    @mock.patch(mock_create_superuser_account_path)
    def test_create_superuser_account_without_optional_fields(self, create_superuser_account_mock):
        create_superuser_account_mock.return_value = self.account

        account = AccountCommand.create_superuser(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
        )

        create_superuser_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
        )

        assert account is not None

    @mock.patch.object(AccountCommand, 'change_password')
    def test_modify_account(self, change_password_mock):
        new_password = generate_password()
        new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)
        groups = [self.group]

        account = AccountCommand.modify(
            account=self.account,
            password=new_password,
            first_name=new_profile_data.first_name,
            last_name=new_profile_data.last_name,
            phone_number=new_profile_data.phone_number,
            avatar=new_profile_data.avatar,
            id_card=new_profile_data.id_card,
            groups=groups,
            is_active=False,
        )

        change_password_mock.assert_called_once_with(account=self.account, password=new_password)
        assert account.profile.first_name == new_profile_data.first_name
        assert account.profile.last_name == new_profile_data.last_name
        assert account.profile.phone_number == new_profile_data.phone_number
        assert account.profile.avatar == new_profile_data.avatar
        assert account.profile.id_card == new_profile_data.id_card
        assert account.is_active is False
        self.assertCountEqual(account.groups.all(), groups)

    @mock.patch.object(AccountCommand, 'change_password')
    def test_modify_account_without_optional_fields(self, change_password_mock):
        account = AccountCommand.modify(account=self.account)

        change_password_mock.assert_not_called()
        assert account.profile.first_name == self.account_profile.first_name
        assert account.profile.last_name == self.account_profile.last_name
        assert account.profile.phone_number == self.account_profile.phone_number
        assert account.profile.avatar == self.account_profile.avatar
        assert account.profile.id_card == self.account_profile.id_card
        assert account.is_active is True

    def test_activate(self):
        account = baker.make(_model=Account, is_active=False)

        AccountCommand.activate(account=account)

        assert account.is_active

    def test_change_password(self):
        account = baker.make(_model=Account, is_active=False)
        password = generate_password()

        AccountCommand.change_password(account=account, password=password)

        assert account.check_password(raw_password=password)

    @mock.patch.object(uuid, 'uuid4')
    def test_anonymize(self, uuid4_mock):
        uuid4_mock.return_value = 'some-uuid'

        car = baker.make(_model=Car)
        permission = baker.make(_model=Permission)

        self.account.cars.add(car)
        self.account.groups.add(self.group)
        self.account.user_permissions.add(permission)

        expected_email = AccountCommand._anonymized_email_schema.format(uuid=uuid4_mock.return_value)

        account = AccountCommand.anonymize(account=self.account)

        assert account.email == expected_email
        assert not account.has_usable_password()
        assert not account.is_active
        assert account.is_anonymized
        assert not account.cars.exists()
        assert not account.groups.exists()
        assert not account.user_permissions.exists()
