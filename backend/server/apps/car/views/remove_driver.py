from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.car.messages.car import CarMessagesEnum
from server.apps.car.models import Car
from server.apps.car.serializers import CarRemoveDriverSerializer
from server.business_logic.car import CarRemoveDriverBL


class CarRemoveDriverView(APIView):
    serializer_class = CarRemoveDriverSerializer
    queryset = Car.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        driver = request.user
        registration_plate = serializer.validated_data['registration_plate']

        CarRemoveDriverBL.process(
            registration_plate=registration_plate,
            driver=driver,
        )

        return Response(
            data={
                'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                    driver_identifier=driver.identifier,
                    registration_plate=registration_plate,
                ),
            },
            status=status.HTTP_204_NO_CONTENT,
        )
