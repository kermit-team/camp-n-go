from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import DjangoModelPermissionsOrAnonReadOnly
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers import CampingPlotDetailsSerializer


class CampingPlotListView(GenericAPIView):
    permission_classes = [DjangoModelPermissionsOrAnonReadOnly]
    serializer_class = CampingPlotDetailsSerializer
    queryset = CampingPlot.objects.all()

    def get(self, request: Request) -> Response:
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)

        return Response(data=serializer.data, status=status.HTTP_200_OK)
