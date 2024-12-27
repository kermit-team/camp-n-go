from unittest import mock

from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.exceptions.group import GroupNotExistsError
from server.apps.account.models import Account, AccountProfile
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import GroupQuery
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
            password=make_password(self.password),
            _fill_optional=True,
        )
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.group = baker.make(_model=Group)

    @mock.patch.object(GroupQuery, 'get_by_name')
    @mock.patch(mock_create_account_path)
    def test_create_account(self, create_account_mock, get_group_by_name_mock):
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
        get_group_by_name_mock.assert_not_called()
        assert not account.groups.exists()

    @mock.patch.object(GroupQuery, 'get_by_name')
    @mock.patch(mock_create_account_path)
    def test_create_account_with_groups(self, create_account_mock, get_group_by_name_mock):
        new_group = baker.make(_model=Group)
        groups = [
            self.group,
            new_group,
        ]

        create_account_mock.return_value = self.account
        get_group_by_name_mock.side_effect = groups

        group_names = ['group1', 'group2']

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
            group_names=group_names,
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
        assert get_group_by_name_mock.call_args_list == [
            mock.call(name=group_name)
            for group_name in group_names
        ]
        assert list(account.groups.all()) == groups

    @mock.patch.object(GroupQuery, 'get_by_name')
    @mock.patch(mock_create_account_path)
    def test_create_account_with_not_existing_groups(self, create_account_mock, get_group_by_name_mock):
        create_account_mock.return_value = self.account
        get_group_by_name_mock.side_effect = Group.DoesNotExist()

        group_names = ['not_existing_group']

        with self.assertRaises(GroupNotExistsError):
            AccountCommand.create(
                email=self.account.email,
                password=self.password,
                first_name=self.account_profile.first_name,
                last_name=self.account_profile.last_name,
                is_superuser=self.account.is_superuser,
                is_active=self.account.is_active,
                phone_number=self.account_profile.phone_number,
                avatar=self.account_profile.avatar,
                id_card=self.account_profile.id_card,
                group_names=group_names,
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

        get_group_by_name_mock.assert_called_once_with(name=group_names[0])

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

    @mock.patch.object(AccountCommand, 'change_password')
    def test_modify_account(self, change_password_mock):
        new_password = generate_password()
        new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)

        account = AccountCommand.modify(
            account=self.account,
            password=new_password,
            first_name=new_profile_data.first_name,
            last_name=new_profile_data.last_name,
            phone_number=new_profile_data.phone_number,
            avatar=new_profile_data.avatar,
            id_card=new_profile_data.id_card,
        )

        change_password_mock.assert_called_once_with(account=self.account, password=new_password)
        assert account.profile.first_name == new_profile_data.first_name
        assert account.profile.last_name == new_profile_data.last_name
        assert account.profile.phone_number == new_profile_data.phone_number
        assert account.profile.avatar == new_profile_data.avatar
        assert account.profile.id_card == new_profile_data.id_card

    @mock.patch.object(AccountCommand, 'change_password')
    def test_modify_account_without_optional_fields(self, change_password_mock):
        account = AccountCommand.modify(account=self.account)

        change_password_mock.assert_not_called()
        assert account.profile.first_name == self.account_profile.first_name
        assert account.profile.last_name == self.account_profile.last_name
        assert account.profile.phone_number == self.account_profile.phone_number
        assert account.profile.avatar == self.account_profile.avatar
        assert account.profile.id_card == self.account_profile.id_card

    def test_activate(self):
        account = baker.make(_model=Account, is_active=False)

        AccountCommand.activate(account=account)

        assert account.is_active

    def test_change_password(self):
        account = baker.make(_model=Account, is_active=False)
        password = generate_password()

        AccountCommand.change_password(account=account, password=password)

        assert account.check_password(raw_password=password)
