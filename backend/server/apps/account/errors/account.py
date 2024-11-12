from enum import Enum


class AccountErrorMessagesEnum(Enum):
    NOT_EXISTS = 'Account {identifier} does not exist.'
    ALREADY_ACTIVE = 'Account {identifier} is already active.'
    INVALID_TOKEN = 'Given token is invalid or expired for account {identifier}.'  # noqa: S105
