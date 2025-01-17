from server.apps.camping.models import Payment


class PaymentQuery:
    @classmethod
    def get_by_stripe_checkout_id(cls, stripe_checkout_id: str) -> Payment:
        return Payment.objects.get(stripe_checkout_id=stripe_checkout_id)
