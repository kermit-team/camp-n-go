from django.db import transaction

from server.apps.account.models import Account
from server.apps.car.models import Car


class CarCommand:
    @classmethod
    @transaction.atomic
    def add(cls, registration_plate: str, driver: Account) -> Car:
        cleaned_registration_plate = ''.join(registration_plate.split())

        car, _ = Car.objects.get_or_create(registration_plate=cleaned_registration_plate)
        car.drivers.add(driver)

        return car

    @classmethod
    def remove_driver(cls, car: Car, driver: Account) -> Car:
        car.drivers.remove(driver)

        return car
