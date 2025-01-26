from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.camping.messages.contact_form import ContactFormMessagesEnum
from server.apps.camping.serializers import ContactFormSerializer
from server.business_logic.mailing.camping import ContactFormConfirmationMail, ContactFormMail


class ContactFormSendView(APIView):
    permission_classes = (AllowAny, )
    serializer_class = ContactFormSerializer

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)

        ContactFormMail.send(
            email=serializer.validated_data['email'],
            content=serializer.validated_data['content'],
        )
        ContactFormConfirmationMail.send(email=serializer.validated_data['email'])

        return Response(
            data={
                'message': ContactFormMessagesEnum.CONTACT_FORM_SEND_SUCCESS.value.format(
                    email=serializer.validated_data['email'],
                ),
            },
            status=status.HTTP_200_OK,
        )
