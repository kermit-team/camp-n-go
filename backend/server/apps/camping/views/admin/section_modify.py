from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import CampingSection
from server.apps.camping.serializers import CampingSectionModifySerializer


class AdminCampingSectionModifyView(GenericAPIView):
    serializer_class = CampingSectionModifySerializer
    queryset = CampingSection.objects.all()

    def put(self, request: Request, pk: int) -> Response:
        return self._update(request=request, pk=pk)

    def patch(self, request: Request, pk: int) -> Response:
        return self._update(request=request, pk=pk, partial=True)

    def _update(self, request: Request, pk: int, partial: bool = False) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_200_OK)
