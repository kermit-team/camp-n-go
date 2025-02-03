from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.exceptions.account import AccountAlreadyActiveError, AccountEmailNotExistsError
from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountEmailVerificationResendBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.queries.account import AccountQuery


class AccountEmailVerificationResendBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.make(_model=Account, is_active=False, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountQuery, 'get_by_email')
    def test_process(self, get_account_by_email_mock, make_token_mock, send_mail_mock):
        get_account_by_email_mock.return_value = self.account

        AccountEmailVerificationResendBL.process(email=self.account.email)

        get_account_by_email_mock.assert_called_once_with(email=self.account.email)
        make_token_mock.assert_called_once_with(user=self.account)
        send_mail_mock.assert_called_once_with(account=self.account, token=make_token_mock.return_value)

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountQuery, 'get_by_email')
    def test_process_for_not_existing_account(self, get_account_by_email_mock, make_token_mock, send_mail_mock):
        email = 'some_not_existing_email'

        get_account_by_email_mock.side_effect = Account.DoesNotExist()

        with self.assertRaises(AccountEmailNotExistsError):
            AccountEmailVerificationResendBL.process(email=email)

        get_account_by_email_mock.assert_called_once_with(email=email)
        make_token_mock.assert_not_called()
        send_mail_mock.assert_not_called()

    @mock.patch.object(AccountEmailVerificationMail, 'send')
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    @mock.patch.object(AccountQuery, 'get_by_email')
    def test_process_for_already_active_account(self, get_account_by_email_mock, make_token_mock, send_mail_mock):
        self.account.is_active = True
        self.account.save()

        get_account_by_email_mock.return_value = self.account

        with self.assertRaises(AccountAlreadyActiveError):
            AccountEmailVerificationResendBL.process(email=self.account.email)

        get_account_by_email_mock.assert_called_once_with(email=self.account.email)
        make_token_mock.assert_not_called()
        send_mail_mock.assert_not_called()
