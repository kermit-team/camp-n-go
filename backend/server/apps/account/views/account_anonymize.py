from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.messages.account import AccountMessagesEnum
from server.apps.account.models import Account
from server.apps.account.permissions import AccountObjectPermissions
from server.business_logic.account import AccountAnonymizeBL
from server.utils.api.permissions import AdminPermissions, DjangoModelPermissionsWithGetPermissions


class AccountAnonymizeView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, (AccountObjectPermissions | AdminPermissions))
    queryset = Account.objects.all()
    lookup_field = 'identifier'

    def delete(self, request: Request, identifier: str) -> Response:
        instance = self.get_object()

        AccountAnonymizeBL.process(account=instance)

        return Response(
            data={
                'message': AccountMessagesEnum.ANONYMIZATION_SUCCESS.value.format(identifier=identifier),
            },
            status=status.HTTP_204_NO_CONTENT,
        )
