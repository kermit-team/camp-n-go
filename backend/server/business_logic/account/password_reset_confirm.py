import uuid

from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_decode

from server.apps.account.exceptions.account import (
    AccountIdentifierNotExistsError,
    AccountInvalidTokenError,
    AccountNotActiveError,
)
from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import AccountQuery


class AccountPasswordResetConfirmBL(AbstractBL):
    _token_generator = PasswordResetTokenGenerator

    @classmethod
    def process(cls, uidb64: str, token: str, password: str) -> None:
        identifier = uuid.UUID(urlsafe_base64_decode(uidb64).decode())
        account = cls._get_account(identifier=identifier)
        cls._validate_token(account=account, token=token)

        AccountCommand.change_password(account=account, password=password)

    @classmethod
    def _validate_token(cls, account: Account, token: str) -> None:
        if not account.is_active:
            raise AccountNotActiveError(identifier=account.identifier)
        if not cls._token_generator().check_token(user=account, token=token):
            raise AccountInvalidTokenError(identifier=account.identifier)

    @classmethod
    def _get_account(cls, identifier: uuid.UUID) -> Account:
        try:
            return AccountQuery.get_by_identifier(identifier=identifier)
        except Account.DoesNotExist:
            raise AccountIdentifierNotExistsError(identifier=identifier)
