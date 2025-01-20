from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.models import Account
from server.apps.account.serializers.admin import AdminAccountModifySerializer


class AdminAccountModifyView(GenericAPIView):
    serializer_class = AdminAccountModifySerializer
    queryset = Account.objects.all()
    lookup_field = 'identifier'

    def put(self, request: Request, identifier: str) -> Response:
        return self._update(request=request, identifier=identifier)

    def patch(self, request: Request, identifier: str) -> Response:
        return self._update(request=request, identifier=identifier, partial=True)

    def _update(self, request: Request, identifier: str, partial: bool = False) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_200_OK)
