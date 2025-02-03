from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.car.messages.car import CarMessagesEnum
from server.apps.car.models import Car
from server.apps.car.permissions import CarObjectPermissions
from server.datastore.commands.car import CarCommand
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions


class CarRemoveDriverView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, CarObjectPermissions)
    queryset = Car.objects.all()

    def delete(self, request: Request, pk: int) -> Response:
        instance = self.get_object()
        driver = request.user

        CarCommand.remove_driver(car=instance, driver=driver)

        return Response(
            data={
                'message': CarMessagesEnum.REMOVE_DRIVER_SUCCESS.value.format(
                    driver_identifier=driver.identifier,
                    registration_plate=instance.registration_plate,
                ),
            },
            status=status.HTTP_204_NO_CONTENT,
        )
