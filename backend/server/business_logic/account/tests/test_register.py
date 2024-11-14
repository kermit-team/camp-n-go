from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountRegisterBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.commands.account import AccountCommand


class AccountRegisterBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountCommand, 'create')
    def test_process(self, create_account_mock, make_token_mock, send_account_email_verification_mock):
        create_account_mock.return_value = self.account

        AccountRegisterBL.process(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

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
            group_names=AccountRegisterBL.default_group_names,
        )
        make_token_mock.assert_called_once_with(user=self.account)
        send_account_email_verification_mock.assert_called_once_with(
            account=self.account,
            token=make_token_mock.return_value,
        )
