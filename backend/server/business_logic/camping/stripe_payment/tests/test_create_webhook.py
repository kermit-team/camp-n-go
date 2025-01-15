from unittest import mock

from django.conf import settings
from django.test import TestCase

from server.apps.camping.exceptions.stripe_payment import (
    StripePaymentInvalidPayloadError,
    StripePaymentUnexpectedEventError,
)
from server.apps.camping.mappings.stripe_payment import STRIPE_EVENT_TYPES_MAPPING
from server.apps.camping.models import PaymentStatus
from server.business_logic.camping.stripe_payment import StripePaymentWebhookBL
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import PaymentQuery


class StripePaymentWebhookBLTestCase(TestCase):
    payload = b''
    signature_header = 'stripe-signature'
    stripe_checkout_id = 'stripe_checkout_id'

    mock_stripe = 'server.business_logic.camping.stripe_payment.webhook.stripe'

    @mock.patch.object(PaymentCommand, 'update_status')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_completed_checkout(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        update_payment_status_mock,
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
        get_payment_by_stripe_checkout_id_mock.assert_called_once_with(
            stripe_checkout_id=self.stripe_checkout_id,
        )
        update_payment_status_mock.assert_called_once_with(
            payment=get_payment_by_stripe_checkout_id_mock.return_value,
            status=PaymentStatus.PAID,
        )

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentCommand, 'update_status')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_expired_checkout(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        update_payment_status_mock,
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
        get_payment_by_stripe_checkout_id_mock.assert_called_once_with(
            stripe_checkout_id=self.stripe_checkout_id,
        )
        update_payment_status_mock.assert_called_once_with(
            payment=get_payment_by_stripe_checkout_id_mock.return_value,
            status=PaymentStatus.UNPAID,
        )

        assert result == stripe_mock.Webhook.construct_event.return_value

    @mock.patch.object(PaymentCommand, 'update_status')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_unexpected_event(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        update_payment_status_mock,
    ):
        stripe_mock.Webhook.construct_event.return_value = mock.MagicMock(
            type='unknown_event',
            data=mock.MagicMock(
                object=mock.MagicMock(
                    id=self.stripe_checkout_id,
                ),
            ),
        )

        with self.assertRaises(StripePaymentUnexpectedEventError):
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
        update_payment_status_mock.assert_not_called()

    @mock.patch.object(PaymentCommand, 'update_status')
    @mock.patch.object(PaymentQuery, 'get_by_stripe_checkout_id')
    @mock.patch(mock_stripe)
    def test_process_for_invalid_payload(
        self,
        stripe_mock,
        get_payment_by_stripe_checkout_id_mock,
        update_payment_status_mock,
    ):
        stripe_mock.Webhook.construct_event.side_effect = ValueError()

        with self.assertRaises(StripePaymentInvalidPayloadError):
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
        update_payment_status_mock.assert_not_called()
