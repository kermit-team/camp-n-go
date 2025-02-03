import uuid
from unittest import mock

from django.test import TestCase
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from model_bakery import baker

from server.apps.account.exceptions.account import (
    AccountAlreadyActiveError,
    AccountIdentifierNotExistsError,
    AccountInvalidTokenError,
)
from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountEmailVerificationBL
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import AccountQuery


class AccountEmailVerificationBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.make(_model=Account, is_active=False, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'activate')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process(self, get_account_by_identifier_mock, activate_account_mock):
        token = AccountEmailVerificationTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        AccountEmailVerificationBL.process(
            uidb64=uidb64,
            token=token,
        )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        activate_account_mock.assert_called_once_with(account=self.account)

    @mock.patch.object(AccountCommand, 'activate')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_not_existing_account(self, get_account_by_identifier_mock, activate_account_mock):
        identifier = uuid.uuid4()
        token = AccountEmailVerificationTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(identifier))

        get_account_by_identifier_mock.side_effect = Account.DoesNotExist()

        with self.assertRaises(AccountIdentifierNotExistsError):
            AccountEmailVerificationBL.process(
                uidb64=uidb64,
                token=token,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=identifier)
        activate_account_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'activate')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_already_active_account(self, get_account_by_identifier_mock, activate_account_mock):
        self.account.is_active = True
        self.account.save()

        token = AccountEmailVerificationTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        with self.assertRaises(AccountAlreadyActiveError):
            AccountEmailVerificationBL.process(
                uidb64=uidb64,
                token=token,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        activate_account_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'activate')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_invalid_token(self, get_account_by_identifier_mock, activate_account_mock):
        new_account = baker.make(_model=Account, is_active=False, _fill_optional=True)

        token = AccountEmailVerificationTokenGenerator().make_token(user=new_account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        with self.assertRaises(AccountInvalidTokenError):
            AccountEmailVerificationBL.process(
                uidb64=uidb64,
                token=token,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        activate_account_mock.assert_not_called()
