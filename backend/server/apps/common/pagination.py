from typing import Any

from rest_framework import status
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response


class StandardPageNumberPagination(PageNumberPagination):
    page_size = 5
    page_size_query_param = 'page_size'
    max_page_size = 100

    def get_paginated_response(self, data: Any) -> Response:
        return Response(
            data={
                'count': self.page.paginator.count,
                'links': {
                    'next': self.get_next_link(),
                    'previous': self.get_previous_link(),
                },
                'page': self.page.number,
                'results': data,
            },
            status=status.HTTP_200_OK,
        )

    def get_paginated_response_schema(self, schema: dict) -> dict:
        return {  # pragma: no cover
            'type': 'object',
            'required': ['count', 'links', 'page', 'results'],
            'properties': {
                'count': {
                    'type': 'integer',
                    'example': 123,
                },
                'links': {
                    'type': 'object',
                    'properties': {
                        'next': {
                            'type': 'string',
                            'nullable': True,
                            'format': 'uri',
                            'example': 'http://api.example.org/?{page_query_param}=3'.format(
                                page_query_param=self.page_query_param,
                            ),
                        },
                        'previous': {
                            'type': 'string',
                            'nullable': True,
                            'format': 'uri',
                            'example': 'http://api.example.org/?{page_query_param}=1'.format(
                                page_query_param=self.page_query_param,
                            ),
                        },
                    },
                },
                'page': {
                    'type': 'integer',
                    'example': 2,
                },
                'results': schema,
            },
        }
