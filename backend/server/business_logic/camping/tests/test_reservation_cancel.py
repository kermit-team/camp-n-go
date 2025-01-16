from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.exceptions.reservation import ReservationCannotBeCancelledError
from server.apps.camping.models import PaymentStatus, Reservation
from server.business_logic.camping import ReservationCancelBL
from server.business_logic.mailing.camping import ReservationCancelMail
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import ReservationQuery


class ReservationCancelBLTestCase(TestCase):
    mock_stripe = 'server.business_logic.camping.reservation_cancel.stripe'

    def setUp(self):
        self.reservation = baker.make(_model=Reservation, _fill_optional=True)

    @mock.patch.object(ReservationCancelMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(ReservationQuery, 'is_reservation_cancellable')
    @mock.patch(mock_stripe)
    def test_process(
        self,
        stripe_mock,
        is_reservation_cancellable_mock,
        modify_payment_mock,
        send_reservation_cancel_mail_mock,
    ):
        is_reservation_cancellable_mock.return_value = True

        ReservationCancelBL.process(reservation=self.reservation)

        is_reservation_cancellable_mock.assert_called_once_with(reservation=self.reservation)
        modify_payment_mock.assert_called_once_with(payment=self.reservation.payment, status=PaymentStatus.CANCELLED)
        stripe_mock.checkout.Session.retrieve.assert_called_once_with(
            id=modify_payment_mock.return_value.stripe_checkout_id,
        )
        stripe_mock.Refund.create.assert_called_once_with(
            payment_intent=stripe_mock.checkout.Session.retrieve.return_value.payment_intent,
        )
        send_reservation_cancel_mail_mock.assert_called_once_with(
            reservation=self.reservation,
        )

    @mock.patch.object(ReservationCancelMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(ReservationQuery, 'is_reservation_cancellable')
    @mock.patch(mock_stripe)
    def test_process_when_reservation_is_not_cancellable(
        self,
        stripe_mock,
        is_reservation_cancellable_mock,
        modify_payment_mock,
        send_reservation_cancel_mail_mock,
    ):
        is_reservation_cancellable_mock.return_value = False

        with self.assertRaises(ReservationCannotBeCancelledError):
            ReservationCancelBL.process(reservation=self.reservation)

        is_reservation_cancellable_mock.assert_called_once_with(reservation=self.reservation)
        modify_payment_mock.assert_not_called()
        stripe_mock.checkout.Session.retrieve.assert_not_called()
        stripe_mock.Refund.create.assert_not_called()
        send_reservation_cancel_mail_mock.assert_not_called()
