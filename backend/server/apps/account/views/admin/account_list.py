from django.db.models import QuerySet
from drf_spectacular.types import OpenApiTypes
from drf_spectacular.utils import OpenApiParameter, OpenApiResponse, extend_schema
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.request import Request
from rest_framework.response import Response

from server.apps.account.filters import AccountListFilter
from server.apps.account.serializers.admin import AdminAccountListElementSerializer
from server.datastore.queries.account import AccountQuery


@extend_schema(
    parameters=[
        OpenApiParameter(
            name='personal_data',
            type=OpenApiTypes.STR,
            location=OpenApiParameter.QUERY,
            required=False,
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
            response=AdminAccountListElementSerializer(many=True),
        ),
    },
)
class AdminAccountListView(GenericAPIView):
    serializer_class = AdminAccountListElementSerializer
    filterset_class = AccountListFilter

    def get_queryset(self) -> QuerySet:
        return AccountQuery.get_queryset_for_account(account=self.request.user)

    def get(self, request: Request) -> Response:
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
