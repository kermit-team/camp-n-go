from server.apps.camping.errors.stripe_payment import StripePaymentErrorMessagesEnum


class StripePaymentInvalidPayloadError(Exception):
    def __init__(self):
        super().__init__(StripePaymentErrorMessagesEnum.INVALID_PAYLOAD.value)


class StripePaymentUnexpectedEventError(Exception):
    def __init__(self, event_type: str):
        super().__init__(
            StripePaymentErrorMessagesEnum.UNEXPECTED_EVENT.value.format(
                event_type=event_type,
            ),
        )
