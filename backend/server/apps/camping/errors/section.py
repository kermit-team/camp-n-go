from enum import Enum

from django.utils.translation import gettext_lazy as _


class CampingSectionErrorMessagesEnum(Enum):
    NOT_EXISTS = _('Camping section {name} does not exist.')
