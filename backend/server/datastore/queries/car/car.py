from server.apps.car.models import Car


class CarQuery:
    @classmethod
    def get_by_registration_plate(cls, registration_plate: str) -> Car:
        return Car.objects.get(registration_plate=registration_plate)
