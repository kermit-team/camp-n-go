from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.account.messages import AccountMessagesEnum
from server.apps.account.serializers import AccountEmailSerializer
from server.business_logic.account import AccountEmailVerificationResendBL


class AccountEmailVerificationResendView(APIView):
    permission_classes = [AllowAny]
    serializer_class = AccountEmailSerializer

    def post(self, request: Request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        AccountEmailVerificationResendBL.process(email=serializer.validated_data['email'])
        return Response(
            data={
                'message': AccountMessagesEnum.EMAIL_VERIFICATION_RESEND_SUCCESS.value.format(
                    email=serializer.validated_data['email'],
                ),
            },
        )
