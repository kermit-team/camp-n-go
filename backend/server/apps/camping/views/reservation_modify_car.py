from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import Reservation
from server.apps.camping.permissions import ReservationObjectPermissions
from server.apps.camping.serializers import ReservationModifyCarSerializer
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions


class ReservationModifyCarView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, ReservationObjectPermissions)
    serializer_class = ReservationModifyCarSerializer
    queryset = Reservation.objects.all()

    def put(self, request: Request, pk: int) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_200_OK)
