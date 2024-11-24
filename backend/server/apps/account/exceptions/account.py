import uuid

from server.apps.account.errors.account import AccountErrorMessagesEnum


class AccountIdentifierNotExistsError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.IDENTIFIER_NOT_EXISTS.value.format(identifier=identifier))


class AccountEmailNotExistsError(Exception):
    def __init__(self, email: str):
        super().__init__(AccountErrorMessagesEnum.EMAIL_NOT_EXISTS.value.format(email=email))


class AccountAlreadyActiveError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.ALREADY_ACTIVE.value.format(identifier=identifier))


class AccountNotActiveError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.NOT_ACTIVE.value.format(identifier=identifier))


class AccountInvalidTokenError(Exception):
    def __init__(self, identifier: uuid.UUID):
        super().__init__(AccountErrorMessagesEnum.INVALID_TOKEN.value.format(identifier=identifier))
