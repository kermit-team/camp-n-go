from django.db.models import QuerySet
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.serializers.group_details import GroupDetailsSerializer
from server.datastore.queries.account import GroupQuery
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions, StaffPermissions


class AdminGroupListView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, StaffPermissions)
    serializer_class = GroupDetailsSerializer

    def get_queryset(self) -> QuerySet:
        return GroupQuery.get_queryset()

    def get(self, request: Request) -> Response:
        queryset = self.filter_queryset(self.get_queryset())
        serializer = self.get_serializer(queryset, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
