from django.contrib.auth.tokens import PasswordResetTokenGenerator

from server.apps.account.models import Account


class AccountEmailVerificationTokenGenerator(PasswordResetTokenGenerator):
    def _make_hash_value(self, account: Account, timestamp: int):  # pragma: no cover
        return (
            str(account.is_active) + str(account.identifier) + str(timestamp)
        )
