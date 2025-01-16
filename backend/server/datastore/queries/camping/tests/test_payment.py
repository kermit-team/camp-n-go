from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import Payment
from server.datastore.queries.camping import PaymentQuery


class PaymentQueryTestCase(TestCase):
    def setUp(self):
        self.payment = baker.make(_model=Payment)

    def test_get_by_stripe_checkout_id(self):
        stripe_checkout_id = self.payment.stripe_checkout_id

        payment = PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=stripe_checkout_id)

        assert payment

    def test_get_by_stripe_checkout_id_without_existing_payment(self):
        stripe_checkout_id = 'not_existing_stripe_checkout_id'

        with self.assertRaises(Payment.DoesNotExist):
            PaymentQuery.get_by_stripe_checkout_id(stripe_checkout_id=stripe_checkout_id)
