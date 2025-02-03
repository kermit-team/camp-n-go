from unittest import mock

from django.conf import settings
from django.test import TestCase

from server.apps.camping.exceptions.stripe_payment import (
    StripeCheckoutSessionNotFoundError,
    StripeEventInvalidPayloadError,
    StripeUnexpectedEventError,
)
from server.apps.camping.mappings.stripe_payment import STRIPE_EVENT_TYPES_MAPPING
from server.apps.camping.models import PaymentStatus
from server.business_logic.camping.stripe_payment import StripePaymentWebhookBL
from server.business_logic.mailing.camping import PaymentExpiredMail, PaymentRefundProcessedMail, PaymentSuccessMail
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import PaymentQuery


class StripePaymentWebhookBLTestCase(TestCase):
    payload = b''
    signature_header = 'stripe-signature'
    stripe_checkout_id = 'stripe_checkout_id'

    mock_stripe = 'server.business_logic.camping.stripe_payment.webhook.stripe'

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_completed_payment(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type=STRIPE_EVENT_TYPES_MAPPING['COMPLETED'],
            data=mock.MagicMock(
                object=mock.MagicMock(
                    id=self.stripe_checkout_id,
                ),
            ),
        )

        result = StripePaymentWebhookBL.process(
            payload=self.payload,
            signature_header=self.signature_header,
        )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        get_payment_by_stripe_checkout_id_mock.assert_called_once_with(stripe_checkout_id=self.stripe_checkout_id)
        modify_payment_mock.assert_called_once_with(
            payment=get_payment_by_stripe_checkout_id_mock.return_value,
            status=PaymentStatus.PAID,
        )
        send_payment_success_mail_mock.assert_called_once_with(
            reservation=get_payment_by_stripe_checkout_id_mock.return_value.reservation,
        )
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_not_called()

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_expired_payment(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type=STRIPE_EVENT_TYPES_MAPPING['EXPIRED'],
            data=mock.MagicMock(
                object=mock.MagicMock(
                    id=self.stripe_checkout_id,
                ),
            ),
        )

        result = StripePaymentWebhookBL.process(
            payload=self.payload,
            signature_header=self.signature_header,
        )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        get_payment_by_stripe_checkout_id_mock.assert_called_once_with(stripe_checkout_id=self.stripe_checkout_id)
        modify_payment_mock.assert_called_once_with(
            payment=get_payment_by_stripe_checkout_id_mock.return_value,
            status=PaymentStatus.UNPAID,
        )
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_called_once_with(
            reservation=get_payment_by_stripe_checkout_id_mock.return_value.reservation,
        )
        send_payment_refund_processed_mail_mock.assert_not_called()

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_processed_payment_refund(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        payment_intent = 'payment_intent'
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type=STRIPE_EVENT_TYPES_MAPPING['REFUNDED'],
            data=mock.MagicMock(
                object=mock.MagicMock(
                    refunded=True,
                    payment_intent=payment_intent,
                ),
            ),
        )
        stripe_mock.checkout.Session.list.return_value = mock.MagicMock(
            data=[
                mock.MagicMock(
                    id=self.stripe_checkout_id,
                ),
            ],
        )

        result = StripePaymentWebhookBL.process(
            payload=self.payload,
            signature_header=self.signature_header,
        )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        stripe_mock.checkout.Session.list.assert_called_once_with(payment_intent=payment_intent, limit=1)
        get_payment_by_stripe_checkout_id_mock.assert_called_once_with(stripe_checkout_id=self.stripe_checkout_id)
        modify_payment_mock.assert_called_once_with(
            payment=get_payment_by_stripe_checkout_id_mock.return_value,
            status=PaymentStatus.REFUNDED,
        )
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_called_once_with(
            reservation=get_payment_by_stripe_checkout_id_mock.return_value.reservation,
        )

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_processed_payment_refund_when_object_is_not_refunded(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        payment_intent = 'payment_intent'
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type=STRIPE_EVENT_TYPES_MAPPING['REFUNDED'],
            data=mock.MagicMock(
                object=mock.MagicMock(
                    refunded=False,
                    payment_intent=payment_intent,
                ),
            ),
        )

        result = StripePaymentWebhookBL.process(
            payload=self.payload,
            signature_header=self.signature_header,
        )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        stripe_mock.checkout.Session.list.assert_not_called()
        get_payment_by_stripe_checkout_id_mock.assert_not_called()
        modify_payment_mock.assert_not_called()
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_not_called()

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_processed_payment_refund_when_checkout_session_not_found_for_given_payment_intent(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        payment_intent = 'payment_intent'
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type=STRIPE_EVENT_TYPES_MAPPING['REFUNDED'],
            data=mock.MagicMock(
                object=mock.MagicMock(
                    refunded=True,
                    payment_intent=payment_intent,
                ),
            ),
        )
        stripe_mock.checkout.Session.list.return_value = mock.MagicMock(data=[])

        with self.assertRaises(StripeCheckoutSessionNotFoundError):
            StripePaymentWebhookBL.process(
                payload=self.payload,
                signature_header=self.signature_header,
            )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        stripe_mock.checkout.Session.list.assert_called_once_with(payment_intent=payment_intent, limit=1)
        get_payment_by_stripe_checkout_id_mock.assert_not_called()
        modify_payment_mock.assert_not_called()
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_not_called()

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_unexpected_event(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type='unknown_event',
            data=mock.MagicMock(
                object=mock.MagicMock(
                    id=self.stripe_checkout_id,
                ),
            ),
        )

        with self.assertRaises(StripeUnexpectedEventError):
            StripePaymentWebhookBL.process(
                payload=self.payload,
                signature_header=self.signature_header,
            )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        get_payment_by_stripe_checkout_id_mock.assert_not_called()
        modify_payment_mock.assert_not_called()
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_not_called()

    @mock.patch.object(PaymentRefundProcessedMail, 'send')
    @mock.patch.object(PaymentExpiredMail, 'send')
    @mock.patch.object(PaymentSuccessMail, 'send')
    @mock.patch.object(PaymentCommand, 'modify')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_invalid_payload(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        modify_payment_mock,
        send_payment_success_mail_mock,
        send_payment_expired_mail_mock,
        send_payment_refund_processed_mail_mock,
    ):
        stripe_mock.Webhook.construct_event.side_effect = ValueError()

        with self.assertRaises(StripeEventInvalidPayloadError):
            StripePaymentWebhookBL.process(
                payload=self.payload,
                signature_header=self.signature_header,
            )

        stripe_mock.Webhook.construct_event.assert_called_once_with(
            payload=self.payload,
            sig_header=self.signature_header,
            secret=settings.STRIPE_WEBHOOK_SIGNING_SECRET,
        )
        get_payment_by_stripe_checkout_id_mock.assert_not_called()
        modify_payment_mock.assert_not_called()
        send_payment_success_mail_mock.assert_not_called()
        send_payment_expired_mail_mock.assert_not_called()
        send_payment_refund_processed_mail_mock.assert_not_called()
