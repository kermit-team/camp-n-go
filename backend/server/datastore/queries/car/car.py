from server.apps.account.models import Account
from server.apps.car.models import Car


class CarQuery:
    @classmethod
    def get_by_registration_plate(cls, registration_plate: str) -> Car:
        return Car.objects.get(registration_plate=registration_plate)

    @classmethod
    def car_belongs_to_user(cls, car: Car, user: Account) -> bool:
        return car.drivers.filter(identifier=user.identifier).exists()
