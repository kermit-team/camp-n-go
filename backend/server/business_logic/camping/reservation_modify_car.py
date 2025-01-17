from typing import Optional

from server.apps.camping.exceptions.reservation import CarNotBelongsToAccountError, ReservationCarCannotBeModifiedError
from server.apps.camping.models import Reservation
from server.apps.car.models import Car
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.camping.reservation import ReservationCommand
from server.datastore.queries.camping import ReservationQuery
from server.datastore.queries.car import CarQuery


class ReservationModifyCarBL(AbstractBL):
    @classmethod
    def process(cls, reservation: Reservation, car: Optional[Car] = None) -> Reservation:
        if not car:
            return reservation

        if not ReservationQuery.is_car_modifiable(reservation=reservation):
            raise ReservationCarCannotBeModifiedError(reservation_id=reservation.id)

        if not CarQuery.car_belongs_to_user(car=car, user=reservation.user):
            raise CarNotBelongsToAccountError(
                registration_plate=car.registration_plate,
                account_identifier=reservation.user.identifier,
            )

        return ReservationCommand.modify(reservation=reservation, car=car)
