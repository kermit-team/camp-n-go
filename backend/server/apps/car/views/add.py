from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.car.models import Car
from server.apps.car.serializers import CarAddSerializer


class CarAddView(GenericAPIView):
    serializer_class = CarAddSerializer
    queryset = Car.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
