from enum import Enum

from django.utils.translation import gettext_lazy as _


class StripePaymentErrorMessagesEnum(Enum):
    INVALID_PAYLOAD = _('Strie payment payload is invalid.')
    UNEXPECTED_EVENT = _('Strie payment payment event type {event_type} is unexpected.')
