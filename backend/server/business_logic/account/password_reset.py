from django.contrib.auth.tokens import PasswordResetTokenGenerator

from server.apps.account.exceptions.account import AccountEmailNotExistsError, AccountNotActiveError
from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.account import AccountPasswordResetMail
from server.datastore.queries.account import AccountQuery


class AccountPasswordResetBL(AbstractBL):
    _token_generator = PasswordResetTokenGenerator

    @classmethod
    def process(cls, email: str) -> None:
        account = cls._get_account(email=email)
        cls._validate_requirements(account=account)

        password_reset_token = cls._token_generator().make_token(user=account)
        AccountPasswordResetMail.send(account=account, token=password_reset_token)

    @classmethod
    def _validate_requirements(cls, account: Account) -> None:
        if not account.is_active:
            raise AccountNotActiveError(identifier=account.identifier)

    @classmethod
    def _get_account(cls, email: str) -> Account:
        try:
            return AccountQuery.get_by_email(email=email)
        except Account.DoesNotExist:
            raise AccountEmailNotExistsError(email=email)
