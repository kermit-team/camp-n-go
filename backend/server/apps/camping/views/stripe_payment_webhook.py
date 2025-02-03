from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.business_logic.camping.stripe_payment import StripePaymentWebhookBL


class StripePaymentWebhookView(APIView):
    permission_classes = (AllowAny, )

    def post(self, request: Request) -> Response:
        payload = request.body
        event = StripePaymentWebhookBL.process(
            payload=payload,
            signature_header=request.META.get('HTTP_STRIPE_SIGNATURE'),
        )

        return Response(
            data={
                'message': StripePaymentMessagesEnum.EVENT_SUCCESS.value.format(event_id=event.id),
            },
            status=status.HTTP_200_OK,
        )
