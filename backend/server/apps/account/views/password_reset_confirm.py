from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.account.serializers import AccountPasswordResetSerializer
from server.business_logic.account import AccountPasswordResetConfirmBL


class AccountPasswordResetConfirmView(APIView):
    permission_classes = [AllowAny]
    serializer_class = AccountPasswordResetSerializer

    def post(self, request: Request, uidb64: str, token: str):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        AccountPasswordResetConfirmBL.process(
            uidb64=uidb64,
            token=token,
            password=serializer.validated_data['password'],
        )
        return Response()
