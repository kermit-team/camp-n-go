from server.apps.car.errors.car import CarErrorMessagesEnum


class CarRegistrationPlateNotExistsError(Exception):
    def __init__(self, registration_plate: str):
        super().__init__(
            CarErrorMessagesEnum.REGISTRATION_PLATE_NOT_EXISTS.value.format(registration_plate=registration_plate),
        )
