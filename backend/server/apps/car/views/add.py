from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.apps.car.models import Car
from server.apps.car.serializers import CarAddSerializer


class CarAddView(APIView):
    serializer_class = CarAddSerializer
    queryset = Car.objects.all()

    def post(self, request: Request) -> Response:
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
