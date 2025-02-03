from enum import Enum

from django.utils.translation import gettext_lazy as _


class GroupErrorMessagesEnum(Enum):
    NOT_EXISTS = _('Group {name} does not exist.')
