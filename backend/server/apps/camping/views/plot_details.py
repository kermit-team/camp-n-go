from typing import Any

from rest_framework import status
from rest_framework.generics import GenericAPIView, get_object_or_404
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers import CampingPlotDetailsSerializer


class CampingPlotDetailsView(GenericAPIView):
    serializer_class = CampingPlotDetailsSerializer
    queryset = CampingPlot.objects.all()
    lookup_fields = ('camping_section__name', 'position')

    def get_object(self) -> Any:
        queryset = self.filter_queryset(self.get_queryset())

        assert all(lookup_field in self.kwargs for lookup_field in self.lookup_fields), (
            'Expected view %s to be called with a URL keyword arguments '
            'named %s. Fix your URL conf, or set the `.lookup_fields` '
            'attribute on the view correctly.' %
            (
                self.__class__.__name__,
                ','.join(['"{field}"'.format(field=field) for field in self.lookup_fields]),
            ),
        )

        filter_kwargs = {}
        for lookup_field in self.lookup_fields:
            filter_kwargs[lookup_field] = self.kwargs[lookup_field]

        obj = get_object_or_404(queryset, **filter_kwargs)

        self.check_object_permissions(self.request, obj)

        return obj

    def get(self, request: Request, camping_section__name: str, position: str) -> Response:
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return Response(data=serializer.data, status=status.HTTP_200_OK)
