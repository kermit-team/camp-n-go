import uuid
from datetime import date

from server.apps.camping.errors.reservation import ReservationErrorMessagesEnum


class AdultMissingForReservationError(Exception):
    def __init__(self):
        super().__init__(ReservationErrorMessagesEnum.ADULT_MISSING.value)


class TooManyPeopleForReservationError(Exception):
    def __init__(
        self,
        camping_plot_section_name: str,
        camping_plot_position: str,
        max_number_of_people: int,
        number_of_people: int,
    ):
        super().__init__(
            ReservationErrorMessagesEnum.TOO_MANY_PEOPLE.value.format(
                camping_plot_section_name=camping_plot_section_name,
                camping_plot_position=camping_plot_position,
                max_number_of_people=max_number_of_people,
                number_of_people=number_of_people,
            ),
        )


class CarNotBelongsToAccountError(Exception):
    def __init__(self, registration_plate: str, account_identifier: uuid.UUID):
        super().__init__(
            ReservationErrorMessagesEnum.CAR_NOT_BELONGS_TO_ACCOUNT.value.format(
                registration_plate=registration_plate,
                account_identifier=account_identifier,
            ),
        )


class IdCardMissingForReservationError(Exception):
    def __init__(self):
        super().__init__(ReservationErrorMessagesEnum.ID_CARD_MISSING.value)


class CampingPlotNotAvailableForReservationError(Exception):
    def __init__(
        self,
        camping_plot_section_name: str,
        camping_plot_position: str,
        date_from: date,
        date_to: date,
        number_of_people: int,
    ):
        super().__init__(
            ReservationErrorMessagesEnum.CAMPING_PLOT_NOT_AVAILABLE.value.format(
                camping_plot_section_name=camping_plot_section_name,
                camping_plot_position=camping_plot_position,
                date_from=date_from,
                date_to=date_to,
                number_of_people=number_of_people,
            ),
        )


class ReservationCannotBeCancelledError(Exception):
    def __init__(self, reservation_id: int):
        super().__init__(
            ReservationErrorMessagesEnum.CANNOT_BE_CANCELLED.value.format(reservation_id=reservation_id),
        )


class ReservationCarCannotBeModifiedError(Exception):
    def __init__(self, reservation_id: int):
        super().__init__(
            ReservationErrorMessagesEnum.CAR_CANNOT_BE_MODIFIED.value.format(reservation_id=reservation_id),
        )
