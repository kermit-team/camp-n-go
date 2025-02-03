from enum import Enum

from django.utils.translation import gettext_lazy as _


class AccountErrorMessagesEnum(Enum):
    IDENTIFIER_NOT_EXISTS = _('Account {identifier} does not exist.')
    EMAIL_NOT_EXISTS = _('Account with email {email} does not exist.')
    ALREADY_ACTIVE = _('Account {identifier} is already active.')
    NOT_ACTIVE = _('Account {identifier} is not active.')
    INVALID_TOKEN = _('Given token is invalid or expired for account {identifier}.')  # noqa: S105
    MISSING_OLD_PASSWORD = _('Old password is required for password change.')
    MISSING_NEW_PASSWORD = _('New password is required for password change.')
    INVALID_PASSWORD = _('Password is incorrect.')
