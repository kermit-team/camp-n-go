from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.car.messages.car import CarMessagesEnum
from server.apps.car.models import Car
from server.datastore.commands.car import CarCommand


class CarRemoveDriverView(GenericAPIView):
    queryset = Car.objects.all()
    lookup_field = 'registration_plate'

    def delete(self, request: Request, registration_plate: str) -> Response:
        car = self.get_object()
        driver = request.user

        CarCommand.remove_driver(car=car, driver=driver)

        return Response(
            data={
                'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                    driver_identifier=driver.identifier,
                    registration_plate=registration_plate,
                ),
            },
            status=status.HTTP_204_NO_CONTENT,
        )
