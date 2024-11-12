from typing import Optional

from django.http import HttpRequest
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from server.business_logic.account.email_verification import AccountEmailVerificationBL


class AccountEmailVerificationView(APIView):
    permission_classes = [AllowAny]

    def get(self, request: HttpRequest, uidb64: Optional[str] = None, token: Optional[str] = None):
        AccountEmailVerificationBL.process(uidb64=uidb64, token=token)
        return Response()
