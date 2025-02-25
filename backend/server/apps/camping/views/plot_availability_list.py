from django.db.models import QuerySet
from drf_spectacular.types import OpenApiTypes
from drf_spectacular.utils import OpenApiParameter, OpenApiResponse, extend_schema
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.filters import CampingPlotAvailabilityFilter
from server.apps.camping.serializers.plot_availability_list_element import CampingPlotAvailabilityListElementSerializer
from server.datastore.queries.camping import CampingPlotQuery


@extend_schema(
    parameters=[
        OpenApiParameter(
            name='number_of_children',
            type=OpenApiTypes.INT,
            location=OpenApiParameter.QUERY,
            required=True,
        ),
        OpenApiParameter(
            name='number_of_adults',
            type=OpenApiTypes.INT,
            location=OpenApiParameter.QUERY,
            required=True,
        ),
        OpenApiParameter(
            name='date_from',
            type=OpenApiTypes.DATE,
            location=OpenApiParameter.QUERY,
            required=True,
        ),
        OpenApiParameter(
            name='date_to',
            type=OpenApiTypes.DATE,
            location=OpenApiParameter.QUERY,
            required=True,
        ),
        OpenApiParameter(
            name='page_size',
            type=OpenApiTypes.INT,
            location=OpenApiParameter.QUERY,
            required=False,
        ),
        OpenApiParameter(
            name='page',
            type=OpenApiTypes.INT,
            location=OpenApiParameter.QUERY,
            required=False,
        ),
    ],
    responses={
        200: OpenApiResponse(
            response=CampingPlotAvailabilityListElementSerializer(many=True),
        ),
    },
)
class CampingPlotAvailabilityListView(GenericAPIView):
    permission_classes = (AllowAny, )
    serializer_class = CampingPlotAvailabilityListElementSerializer
    filterset_class = CampingPlotAvailabilityFilter

    def get_queryset(self) -> QuerySet:
        return CampingPlotQuery.get_queryset()

    def get(self, request: Request) -> Response:
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
