from server.apps.account.errors.group import GroupErrorMessagesEnum


class GroupNotExistsError(Exception):
    def __init__(self, name: str):
        super().__init__(GroupErrorMessagesEnum.NOT_EXISTS.value.format(name=name))
