import logging
import re

import pytest
from django.conf import settings
from django.http.response import ResponseHeaders
from rest_framework import status
from rest_framework.exceptions import NotFound, ParseError, PermissionDenied, ValidationError
from rest_framework.test import APITestCase

from server.utils.api.exception_handler import custom_exception_handler


class CustomExceptionHandlerTestCase(APITestCase):
    @pytest.fixture(autouse=True)
    def injectcaplog(self, caplog):
        self.caplog = caplog

    def test_handling_for_missing_error(self):
        exc = ValidationError(
            detail={'some_field': ['text']},
            code='required',
        )
        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert response.data == settings.API_MISSING_MESSAGE

        self._validate_cid_header(headers=response.headers)

    def test_handling_for_parsing_error(self):
        exc = ParseError()
        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert response.data == settings.API_ERROR_MESSAGE
        self._validate_cid_header(headers=response.headers)

    def test_handling_for_not_found_error(self):
        exc = NotFound()
        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        assert response.status_code == status.HTTP_404_NOT_FOUND
        assert response.data == settings.API_ERROR_MESSAGE
        self._validate_cid_header(headers=response.headers)

    def test_handling_for_permission_denied_error(self):
        exc = PermissionDenied()
        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        assert response.status_code == status.HTTP_403_FORBIDDEN
        assert response.data == settings.API_ERROR_MESSAGE
        self._validate_cid_header(headers=response.headers)

    def test_handling_for_integral_server_error(self):
        exc = Exception('Server exception')

        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert response.data == settings.API_ERROR_MESSAGE
        self._validate_cid_header(headers=response.headers)

    def test_cid_generator(self):
        exc = ValidationError(
            detail={'some_field': ['text']},
            code='required',
        )
        pattern = '[a-zA-Z0-9]{{{length}}}'.format(length=settings.CID_LENGTH)

        with self.caplog.at_level(logging.DEBUG):
            response = custom_exception_handler(exc=exc, context={})

        cid = response.headers.get('X-Correlation-Id')

        assert cid
        assert len(cid) == settings.CID_LENGTH
        assert re.match(pattern=pattern, string=cid)

    def _validate_cid_header(self, headers: ResponseHeaders) -> None:
        assert 'X-Correlation-Id' in headers
        assert headers['X-Correlation-Id'] == self.caplog.records[0].cid
