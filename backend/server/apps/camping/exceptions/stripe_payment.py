from server.apps.camping.errors.stripe_payment import StripeErrorMessagesEnum


class StripeEventInvalidPayloadError(Exception):
    def __init__(self):
        super().__init__(StripeErrorMessagesEnum.INVALID_EVENT_PAYLOAD.value)


class StripeUnexpectedEventError(Exception):
    def __init__(self, event_type: str):
        super().__init__(
            StripeErrorMessagesEnum.UNEXPECTED_EVENT.value.format(
                event_type=event_type,
            ),
        )


class StripeCheckoutSessionNotFoundError(Exception):
    def __init__(self, payment_intent: str):
        super().__init__(
            StripeErrorMessagesEnum.CHECKOUT_SESSION_NOT_FOUND.value.format(
                payment_intent=payment_intent,
            ),
        )
