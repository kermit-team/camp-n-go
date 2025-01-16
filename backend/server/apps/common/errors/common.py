from enum import Enum

from django.utils.translation import gettext_lazy as _


class CommonErrorMessagesEnum(Enum):
    INVALID_DATE_VALUES = _('Date from {date_from} must be before Date to {date_to}.')
    DATE_IN_THE_PAST = _('Date {given_date} is not upcoming.')
