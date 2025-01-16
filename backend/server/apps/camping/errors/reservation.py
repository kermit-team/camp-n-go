from enum import Enum

from django.utils.translation import gettext_lazy as _


class ReservationErrorMessagesEnum(Enum):
    ADULT_MISSING = _('Adult person is required to make a reservation.')
    TOO_MANY_PEOPLE = _(
        'Camping plot {camping_plot_section_name}_{camping_plot_position} '
        'can hold maximum of {max_number_of_people} people, '
        'while {number_of_people} people was given for reservation.',
    )
    CAR_NOT_BELONGS_TO_ACCOUNT = _('Car {registration_plate} does not belong to account {account_identifier}.')
    ID_CARD_MISSING = _('Id card is required to make a reservation.')
    CAMPING_PLOT_NOT_AVAILABLE = _(
        'Camping plot {camping_plot_section_name}_{camping_plot_position} is not available during the period of '
        '{date_from} - {date_to} for {number_of_people} people.',
    )
    CANNOT_BE_CANCELLED = _('Reservation {reservation_id} cannot be cancelled.')
    CAR_CANNOT_BE_MODIFIED = _('Reservation {reservation_id} car cannot be modified.')
