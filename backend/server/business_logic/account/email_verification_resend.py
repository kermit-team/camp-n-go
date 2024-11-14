from server.apps.account.exceptions.account import AccountAlreadyActiveError, AccountEmailNotExistsError
from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.queries.account import AccountQuery


class AccountEmailVerificationResendBL(AbstractBL):
    _token_generator = AccountEmailVerificationTokenGenerator

    @classmethod
    def process(cls, email: str) -> None:
        account = cls._get_account(email=email)
        cls._validate_requirements(account=account)

        email_verification_token = cls._token_generator().make_token(user=account)
        AccountEmailVerificationMail.send(account=account, token=email_verification_token)

    @classmethod
    def _validate_requirements(cls, account: Account) -> None:
        if account.is_active:
            raise AccountAlreadyActiveError(identifier=account.identifier)

    @classmethod
    def _get_account(cls, email: str) -> Account:
        try:
            return AccountQuery.get_by_email(email=email)
        except (Account.DoesNotExist):
            raise AccountEmailNotExistsError(email=email)
