from datetime import date

from server.apps.account.models import Account
from server.apps.camping.models import PaymentStatus, Reservation
from server.apps.car.models import Car


class CarQuery:
    @classmethod
    def get_by_registration_plate(cls, registration_plate: str) -> Car:
        return Car.objects.get(registration_plate=registration_plate)

    @classmethod
    def car_belongs_to_user(cls, car: Car, user: Account) -> bool:
        return car.drivers.filter(identifier=user.identifier).exists()

    @classmethod
    def is_car_able_to_enter(cls, registration_plate: str) -> bool:
        current_day = date.today()

        return Reservation.objects.filter(
            car__registration_plate=registration_plate,
            date_from__lte=current_day,
            date_to__gte=current_day,
            payment__status=PaymentStatus.PAID,
        ).exists()
