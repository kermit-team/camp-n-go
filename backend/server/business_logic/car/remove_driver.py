from server.apps.account.models import Account
from server.apps.car.exceptions.car import CarRegistrationPlateNotExistsError
from server.apps.car.models import Car
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.car import CarCommand
from server.datastore.queries.car import CarQuery


class CarRemoveDriverBL(AbstractBL):

    @classmethod
    def process(cls, registration_plate: str, driver: Account) -> None:
        car = cls._get_car(registration_plate=registration_plate)
        CarCommand.remove_driver(car=car, driver=driver)

    @classmethod
    def _get_car(cls, registration_plate: str) -> Car:
        try:
            return CarQuery.get_by_registration_plate(registration_plate=registration_plate)
        except Car.DoesNotExist:
            raise CarRegistrationPlateNotExistsError(registration_plate=registration_plate)
