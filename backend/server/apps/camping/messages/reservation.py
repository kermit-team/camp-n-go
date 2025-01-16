from enum import Enum

from django.utils.translation import gettext_lazy as _


class ReservationMessagesEnum(Enum):
    CANCELLATION_SUCCESS = _('Reservation was successfully cancelled.')
