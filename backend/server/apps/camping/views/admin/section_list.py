from django.db.models import QuerySet
from drf_spectacular.types import OpenApiTypes
from drf_spectacular.utils import OpenApiParameter, OpenApiResponse, extend_schema
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.camping.serializers import CampingSectionDetailsSerializer
from server.datastore.queries.camping import CampingSectionQuery
from server.utils.api.permissions import DjangoModelPermissionsWithGetPermissions, StaffPermissions


@extend_schema(
    parameters=[
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
            response=CampingSectionDetailsSerializer(many=True),
        ),
    },
)
class AdminCampingSectionListView(GenericAPIView):
    permission_classes = (DjangoModelPermissionsWithGetPermissions, StaffPermissions)
    serializer_class = CampingSectionDetailsSerializer

    def get_queryset(self) -> QuerySet:
        return CampingSectionQuery.get_queryset()

    def get(self, request: Request) -> Response:
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
