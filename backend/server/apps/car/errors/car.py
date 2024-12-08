from enum import Enum

from django.utils.translation import gettext_lazy as _


class CarErrorMessagesEnum(Enum):
    REGISTRATION_PLATE_NOT_EXISTS = _('Car {registration_plate} does not exist.')
