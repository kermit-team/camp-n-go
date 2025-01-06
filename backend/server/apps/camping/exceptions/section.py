from server.apps.camping.errors.section import CampingSectionErrorMessagesEnum


class CampingSectionNotExistsError(Exception):
    def __init__(self, name: str):
        super().__init__(CampingSectionErrorMessagesEnum.NOT_EXISTS.value.format(name=name))
