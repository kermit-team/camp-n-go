from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import CampingSection
from server.apps.camping.serializers import CampingSectionModifySerializer


class CampingSectionModifyView(GenericAPIView):
    serializer_class = CampingSectionModifySerializer
    queryset = CampingSection.objects.all()
    lookup_field = 'name'

    def put(self, request: Request, name: str) -> Response:
        return self._update(request=request, name=name)

    def patch(self, request: Request, name: str) -> Response:
        return self._update(request=request, name=name, partial=True)

    def _update(self, request: Request, name: str, partial: bool = False) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(data=serializer.data, status=status.HTTP_200_OK)
