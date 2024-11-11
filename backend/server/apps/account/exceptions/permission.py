from server.apps.account.errors.permission import PermissionErrorMessagesEnum


class PermissionNotExistsError(Exception):
    def __init__(self, codename: str):
        super().__init__(PermissionErrorMessagesEnum.NOT_EXISTS.value.format(codename=codename))
