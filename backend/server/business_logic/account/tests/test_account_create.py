from unittest import mock

from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.exceptions.group import GroupNotExistsError
from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountCreateBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import GroupQuery


class AccountCreateBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountCommand, 'create')
    @mock.patch.object(GroupQuery, 'get_by_name')
    def test_process(
        self,
        get_group_by_name_mock,
        create_account_mock,
        make_token_mock,
        send_account_email_verification_mock,
    ):
        groups = baker.make(_model=Group, _fill_optional=True, _quantity=2)
        create_account_mock.return_value = self.account

        AccountCreateBL.process(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            groups=groups,
        )

        get_group_by_name_mock.assert_not_called()
        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_superuser=False,
            is_active=False,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            groups=groups,
        )
        make_token_mock.assert_called_once_with(user=self.account)
        send_account_email_verification_mock.assert_called_once_with(
            account=self.account,
            token=make_token_mock.return_value,
        )

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountCommand, 'create')
    @mock.patch.object(GroupQuery, 'get_by_name')
    def test_process_without_groups(
        self,
        get_group_by_name_mock,
        create_account_mock,
        make_token_mock,
        send_account_email_verification_mock,
    ):
        groups = [Group.objects.create(name=group_name) for group_name in AccountCreateBL.default_group_names]

        get_group_by_name_mock.side_effect = groups
        create_account_mock.return_value = self.account

        AccountCreateBL.process(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        assert get_group_by_name_mock.call_args_list == [
            mock.call(name=group_name) for group_name in AccountCreateBL.default_group_names
        ]
        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_superuser=False,
            is_active=False,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            groups=groups,
        )
        make_token_mock.assert_called_once_with(user=self.account)
        send_account_email_verification_mock.assert_called_once_with(
            account=self.account,
            token=make_token_mock.return_value,
        )

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountCommand, 'create')
    @mock.patch.object(GroupQuery, 'get_by_name')
    def test_process_without_groups_when_default_groups_not_exist(
        self,
        get_group_by_name_mock,
        create_account_mock,
        make_token_mock,
        send_account_email_verification_mock,
    ):
        get_group_by_name_mock.side_effect = Group.DoesNotExist
        create_account_mock.return_value = self.account

        with self.assertRaises(GroupNotExistsError):
            AccountCreateBL.process(
                email=self.account.email,
                password=self.account.password,
                first_name=self.account_profile.first_name,
                last_name=self.account_profile.last_name,
                phone_number=self.account_profile.phone_number,
                avatar=self.account_profile.avatar,
                id_card=self.account_profile.id_card,
            )

        get_group_by_name_mock.assert_called_once_with(
            name=AccountCreateBL.default_group_names[0],
        )
        create_account_mock.assert_not_called()
        make_token_mock.assert_not_called()
        send_account_email_verification_mock.assert_not_called()
