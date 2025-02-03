from enum import Enum

from django.utils.translation import gettext_lazy as _


class PermissionErrorMessagesEnum(Enum):
    NOT_EXISTS = _('Permission {codename} does not exist.')
