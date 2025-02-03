from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.car.serializers import CarEntrySerializer
from server.datastore.queries.car import CarQuery


class CarEntryView(APIView):
    permission_classes = (AllowAny, )
    serializer_class = CarEntrySerializer

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        is_car_able_to_enter = CarQuery.is_car_able_to_enter(
            registration_plate=serializer.validated_data['registration_plate'],
        )

        return Response(
            data={'message': is_car_able_to_enter},
            status=status.HTTP_200_OK,
        )
