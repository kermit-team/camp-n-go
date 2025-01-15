import logging

import stripe
from django.conf import settings

from server.apps.camping.exceptions.stripe_payment import (
    StripePaymentInvalidPayloadError,
    StripePaymentUnexpectedEventError,
)
from server.apps.camping.mappings.stripe_payment import STRIPE_EVENT_TYPES_MAPPING
from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.apps.camping.models import PaymentStatus
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import PaymentQuery

logger = logging.getLogger(__name__)


class StripePaymentWebhookBL(AbstractBL):
    stripe.api_key = settings.STRIPE_API_KEY

    @classmethod
    def process(cls, payload: bytes, signature_header: str) -> stripe.Event:
        event = cls._get_event(payload=payload, signature_header=signature_header)

        if event.type == STRIPE_EVENT_TYPES_MAPPING['COMPLETED']:
            new_status = PaymentStatus.PAID
            cls._handle_checkout(event=event, new_status=new_status)
        elif event.type == STRIPE_EVENT_TYPES_MAPPING['EXPIRED']:
            new_status = PaymentStatus.UNPAID
            cls._handle_checkout(event=event, new_status=new_status)
        else:
            cls._handle_unexpected_event(event=event)
        return event

    @classmethod
    def _get_event(cls, payload: bytes, signature_header: str) -> stripe.Event:
        try:
            event = stripe.Webhook.construct_event(
                payload=payload,
                sig_header=signature_header,
                secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
            )
        except ValueError:
            raise StripePaymentInvalidPayloadError()

        return event

    @classmethod
    def _handle_checkout(cls, event: stripe.Event, new_status: PaymentStatus) -> None:
        stripe_checkout_id = event.data.object.id
        payment = PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=stripe_checkout_id)
        PaymentCommand.update_status(
            payment=payment,
            status=new_status,
        )

        logger.info(
            StripePaymentMessagesEnum.PAYMENT_STATUS_CHANGED.value.format(
                stripe_checkout_id=stripe_checkout_id,
                status=new_status.name,
            ),
        )

    @classmethod
    def _handle_unexpected_event(cls, event: stripe.Event) -> None:
        raise StripePaymentUnexpectedEventError(event_type=event.type)
