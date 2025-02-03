from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountAnonymizeBL
from server.datastore.commands.account import AccountCommand, AccountProfileCommand


class AccountAnonymizeBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'anonymize')
    @mock.patch.object(AccountProfileCommand, 'anonymize')
    def test_process(self, anonymize_account_profile_command_mock, anonymize_account_command_mock):
        anonymize_account_command_mock.return_value = self.account

        AccountAnonymizeBL.process(account=self.account)

        anonymize_account_profile_command_mock.assert_called_once_with(account_profile=self.account_profile)
        anonymize_account_command_mock.assert_called_once_with(account=self.account)
