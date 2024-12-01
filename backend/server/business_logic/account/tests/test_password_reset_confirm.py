import uuid
from unittest import mock

from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.test import TestCase
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from model_bakery import baker

from server.apps.account.exceptions.account import (
    AccountIdentifierNotExistsError,
    AccountInvalidTokenError,
    AccountNotActiveError,
)
from server.apps.account.models import Account, AccountProfile
from server.business_logic.account import AccountPasswordResetConfirmBL
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import AccountQuery


class AccountPasswordResetConfirmBLTestCase(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.new_password = 'some_password'

    def setUp(self):
        self.account = baker.make(_model=Account, is_active=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'change_password')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process(self, get_account_by_identifier_mock, change_password_mock):
        token = PasswordResetTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        AccountPasswordResetConfirmBL.process(
            uidb64=uidb64,
            token=token,
            password=self.new_password,
        )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        change_password_mock.assert_called_once_with(account=self.account, password=self.new_password)

    @mock.patch.object(AccountCommand, 'change_password')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_not_existing_account(self, get_account_by_identifier_mock, change_password_mock):
        identifier = uuid.uuid4()
        token = PasswordResetTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(identifier))

        get_account_by_identifier_mock.side_effect = Account.DoesNotExist()

        with self.assertRaises(AccountIdentifierNotExistsError):
            AccountPasswordResetConfirmBL.process(
                uidb64=uidb64,
                token=token,
                password=self.new_password,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=identifier)
        change_password_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'change_password')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_inactive_account(self, get_account_by_identifier_mock, change_password_mock):
        self.account.is_active = False
        self.account.save()

        token = PasswordResetTokenGenerator().make_token(user=self.account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        with self.assertRaises(AccountNotActiveError):
            AccountPasswordResetConfirmBL.process(
                uidb64=uidb64,
                token=token,
                password=self.new_password,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        change_password_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'change_password')
    @mock.patch.object(AccountQuery, 'get_by_identifier')
    def test_process_for_invalid_token(self, get_account_by_identifier_mock, change_password_mock):
        new_account = baker.make(_model=Account, is_active=False, _fill_optional=True)

        token = PasswordResetTokenGenerator().make_token(user=new_account)
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))

        get_account_by_identifier_mock.return_value = self.account

        with self.assertRaises(AccountInvalidTokenError):
            AccountPasswordResetConfirmBL.process(
                uidb64=uidb64,
                token=token,
                password=self.new_password,
            )

        get_account_by_identifier_mock.assert_called_once_with(identifier=self.account.identifier)
        change_password_mock.assert_not_called()
