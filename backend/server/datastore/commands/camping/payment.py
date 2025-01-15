from server.apps.camping.models import Payment, PaymentStatus


class PaymentCommand:
    @classmethod
    def update_status(cls, payment: Payment, status: PaymentStatus) -> Payment:
        payment.status = status
        payment.save()
        return payment
