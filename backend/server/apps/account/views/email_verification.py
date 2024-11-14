from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.business_logic.account import AccountEmailVerificationBL


class AccountEmailVerificationView(APIView):
    permission_classes = [AllowAny]

    def get(self, request: Request, uidb64: str, token: str):
        AccountEmailVerificationBL.process(uidb64=uidb64, token=token)
        return Response()
