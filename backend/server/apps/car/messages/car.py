from enum import Enum

from django.utils.translation import gettext_lazy as _


class CarMessagesEnum(Enum):
    REMOVE_DRIVER_SUCCESS = _('Successfully removed driver {driver_identifier} from car {registration_plate}.')
