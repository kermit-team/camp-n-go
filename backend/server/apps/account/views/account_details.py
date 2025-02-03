from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.models import Account
from server.apps.account.permissions import AccountObjectPermissions
from server.apps.account.serializers import AccountDetailsSerializer
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions, StaffPermissions


class AccountDetailsView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, (AccountObjectPermissions | StaffPermissions))
    serializer_class = AccountDetailsSerializer
    queryset = Account.objects.all()
    lookup_field = 'identifier'

    def get(self, request: Request, identifier: str) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return Response(data=serializer.data, status=status.HTTP_200_OK)
