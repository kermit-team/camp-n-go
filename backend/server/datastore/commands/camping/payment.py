from server.apps.camping.models import Payment


class PaymentCommand:
    @classmethod
    def modify(cls, payment: Payment, **kwargs) -> Payment:
        for field, value in kwargs.items():
            setattr(payment, field, value)

        payment.save()
        return payment
