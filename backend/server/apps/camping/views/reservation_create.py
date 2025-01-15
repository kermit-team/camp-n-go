from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import Reservation
from server.apps.camping.serializers import ReservationCreateSerializer


class ReservationCreateView(GenericAPIView):
    serializer_class = ReservationCreateSerializer
    queryset = Reservation.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
