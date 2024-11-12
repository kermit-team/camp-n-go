import uuid

from server.apps.account.errors.account import AccountErrorMessagesEnum


class AccountNotExistsError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.NOT_EXISTS.value.format(identifier=identifier))


class AccountAlreadyActiveError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.ALREADY_ACTIVE.value.format(identifier=identifier))


class AccountEmailVerificationTokenError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.INVALID_TOKEN.value.format(identifier=identifier))
