from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import Payment, PaymentStatus
from server.datastore.commands.camping import PaymentCommand


class PaymentCommandTestCase(TestCase):
    def setUp(self):
        self.payment = baker.make(_model=Payment, status=PaymentStatus.WAITING_FOR_PAYMENT)

    def test_update_status(self):
        new_status = PaymentStatus.PAID
        payment = PaymentCommand.update_status(payment=self.payment, status=new_status)

        assert payment.status == new_status
