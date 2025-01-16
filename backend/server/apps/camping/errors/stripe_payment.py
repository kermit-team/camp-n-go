from enum import Enum

from django.utils.translation import gettext_lazy as _


class StripeErrorMessagesEnum(Enum):
    INVALID_EVENT_PAYLOAD = _('Stripe event payload is invalid.')
    UNEXPECTED_EVENT = _('Stripe event type {event_type} is unexpected.')
    CHECKOUT_SESSION_NOT_FOUND = _('Stripe checkout session not found for payment intent {payment_intent}.')
