from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import CampingSection
from server.apps.camping.serializers import CampingSectionDetailsSerializer
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions, StaffPermissions


class AdminCampingSectionDetailsView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, StaffPermissions)
    serializer_class = CampingSectionDetailsSerializer
    queryset = CampingSection.objects.all()

    def get(self, request: Request, pk: int) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return Response(data=serializer.data, status=status.HTTP_200_OK)
