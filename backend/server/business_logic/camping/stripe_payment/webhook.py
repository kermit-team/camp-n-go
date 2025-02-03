import logging

import stripe
from django.conf import settings

from server.apps.camping.exceptions.stripe_payment import (
    StripeCheckoutSessionNotFoundError,
    StripeEventInvalidPayloadError,
    StripeUnexpectedEventError,
)
from server.apps.camping.mappings.stripe_payment import STRIPE_EVENT_TYPES_MAPPING
from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.apps.camping.models import Payment, PaymentStatus
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.camping import PaymentExpiredMail, PaymentRefundProcessedMail, PaymentSuccessMail
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import PaymentQuery

logger = logging.getLogger(__name__)


class StripePaymentWebhookBL(AbstractBL):
    stripe.api_key = settings.STRIPE_API_KEY

    handler_mapping = {
        STRIPE_EVENT_TYPES_MAPPING['COMPLETED']: '_handle_completed_payment',
        STRIPE_EVENT_TYPES_MAPPING['EXPIRED']: '_handle_expired_payment',
        STRIPE_EVENT_TYPES_MAPPING['REFUNDED']: '_handle_processed_payment_refund',
    }

    @classmethod
    def process(cls, payload: bytes, signature_header: str) -> stripe.Event:
        event = cls._get_event(payload=payload, signature_header=signature_header)

        handler_name = cls.handler_mapping.get(event.type, '_handle_unexpected_event')
        handler = getattr(cls, handler_name)
        return handler(event)

    @classmethod
    def _get_event(cls, payload: bytes, signature_header: str) -> stripe.Event:
        try:
            event = stripe.Webhook.construct_event(
                payload=payload,
                sig_header=signature_header,
                secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
            )
        except ValueError:
            raise StripeEventInvalidPayloadError()

        return event

    @classmethod
    def _handle_completed_payment(cls, event: stripe.Event) -> stripe.Event:
        payment = PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=event.data.object.id)
        new_status = PaymentStatus.PAID
        cls._update_payment_status(payment=payment, new_status=new_status)
        PaymentSuccessMail.send(reservation=payment.reservation)

        return event

    @classmethod
    def _handle_expired_payment(cls, event: stripe.Event) -> stripe.Event:
        payment = PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=event.data.object.id)
        new_status = PaymentStatus.UNPAID
        cls._update_payment_status(payment=payment, new_status=new_status)
        PaymentExpiredMail.send(reservation=payment.reservation)

        return event

    @classmethod
    def _handle_processed_payment_refund(cls, event: stripe.Event) -> stripe.Event:
        if event.data.object.refunded is not True:
            return event

        checkout_sessions = stripe.checkout.Session.list(payment_intent=event.data.object.payment_intent, limit=1)

        if not checkout_sessions.data:
            raise StripeCheckoutSessionNotFoundError(
                payment_intent=event.data.object.payment_intent,
            )

        payment = PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=checkout_sessions.data[0].id)
        new_status = PaymentStatus.REFUNDED
        cls._update_payment_status(payment=payment, new_status=new_status)
        PaymentRefundProcessedMail.send(reservation=payment.reservation)

        return event

    @classmethod
    def _update_payment_status(cls, payment: Payment, new_status: PaymentStatus) -> None:
        PaymentCommand.modify(payment=payment, status=new_status)
        logger.info(
            StripePaymentMessagesEnum.PAYMENT_STATUS_CHANGED.value.format(
                stripe_checkout_id=payment.stripe_checkout_id,
                status=new_status.name,
            ),
        )

    @classmethod
    def _handle_unexpected_event(cls, event: stripe.Event) -> None:
        raise StripeUnexpectedEventError(event_type=event.type)
