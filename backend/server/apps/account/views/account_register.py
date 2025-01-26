from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.models import Account
from server.apps.account.serializers import AccountRegisterSerializer


class AccountRegisterView(GenericAPIView):
    permission_classes = (AllowAny, )
    serializer_class = AccountRegisterSerializer
    queryset = Account.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
