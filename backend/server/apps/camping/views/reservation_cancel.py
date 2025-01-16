from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.messages.reservation import ReservationMessagesEnum
from server.apps.camping.models import Reservation
from server.business_logic.camping import ReservationCancelBL


class ReservationCancelView(GenericAPIView):
    queryset = Reservation.objects.all()

    def patch(self, request: Request, pk: int) -> Response:
        instance = self.get_object()
        ReservationCancelBL.process(reservation=instance)

        return Response(
            data={
                'message': ReservationMessagesEnum.CANCELLATION_SUCCESS.value,
            },
            status=status.HTTP_200_OK,
        )
