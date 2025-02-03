import logging
from typing import Any

from cid.locals import generate_new_cid, set_cid
from django.conf import settings
from rest_framework import status
from rest_framework.exceptions import ValidationError
from rest_framework.response import Response
from rest_framework.views import exception_handler

logger = logging.getLogger(__name__)


def custom_exception_handler(exc: Exception, context: Any) -> Response:
    response = exception_handler(exc=exc, context=context)
    new_cid = generate_new_cid()
    set_cid(new_cid)

    response = get_api_error_response(exc, response) if response else get_server_error_response(exc)
    response.headers['X-Correlation-Id'] = new_cid

    return response


def get_api_error_response(exc: Exception, response: Response) -> Response:
    data = response.data
    if isinstance(exc, ValidationError):
        is_missing = is_missing_dict(exc.get_codes()) if isinstance(data, dict) else False
        response.data = settings.API_MISSING_MESSAGE if is_missing else settings.API_ERROR_MESSAGE
    else:
        response.data = settings.API_ERROR_MESSAGE
    logger.debug(data)

    return response


def get_server_error_response(exc: Exception) -> Response:
    logger.exception(exc)
    return Response(data=settings.API_ERROR_MESSAGE, status=status.HTTP_400_BAD_REQUEST)


def is_missing_dict(error_codes: dict) -> bool:
    return any(error == 'required' for error_code in error_codes.values() for error in error_code)
