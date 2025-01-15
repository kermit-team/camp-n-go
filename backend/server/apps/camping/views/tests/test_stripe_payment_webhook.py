import json
from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.apps.camping.views import StripePaymentWebhookView
from server.business_logic.camping.stripe_payment import StripePaymentWebhookBL


class StripePaymentWebhookViewTestCase(APITestCase):
    mock_stripe = 'server.apps.camping.serializers.reservation_create.stripe'

    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = StripePaymentWebhookView

    @mock.patch.object(StripePaymentWebhookBL, 'process')
    def test_request(self, stripe_payment_webhook_mock):
        request_data = {}
        signature_header = 'stripe_signature'
        headers = {'STRIPE_SIGNATURE': signature_header}
        url = reverse('payment_webhook')

        expected_payload = json.dumps(request_data).encode('utf-8')
        expected_data = {
            'message': StripePaymentMessagesEnum.EVENT_SUCCESS.value.format(
                event_id=stripe_payment_webhook_mock.return_value.id,
            ),
        }

        req = self.factory.post(url, data=request_data, headers=headers)
        res = self.view.as_view()(req)

        stripe_payment_webhook_mock.assert_called_once_with(
            payload=expected_payload,
            signature_header=signature_header,
        )

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data
