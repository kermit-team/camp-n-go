from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.account.models import Account
from server.apps.account.serializers.admin import AdminAccountCreateSerializer


class AdminAccountCreateView(APIView):
    serializer_class = AdminAccountCreateSerializer
    queryset = Account.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
