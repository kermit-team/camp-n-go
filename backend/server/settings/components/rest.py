import os

from django.utils.translation import gettext_lazy as _

from server.apps.common.errors.common_base import CommonErrorsEnum
from server.settings.components.camping import DRF_SPECTACULAR_ON
from server.settings.components.common import DATETIME_INPUT_FORMATS

REST_FRAMEWORK = {
    'DATETIME_FORMAT': DATETIME_INPUT_FORMATS[0],
    'DATETIME_INPUT_FORMATS': DATETIME_INPUT_FORMATS,
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
    ],
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
    ],
    'DEFAULT_PAGINATION_CLASS': 'server.apps.common.pagination.StandardPageNumberPagination',
    'DEFAULT_PERMISSION_CLASSES': [
        'server.utils.api.permissions.DjangoModelPermissionsWithGetPermissions',
    ],
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
    ),
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
    'EXCEPTION_HANDLER': 'server.utils.api.exception_handler.custom_exception_handler',
    'PAGE_SIZE': int(os.getenv('REST_PAGE_SIZE', 10)),
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': os.getenv('THROTTLING_RATE_ANONYMOUS', '200/minute'),
        'user': os.getenv('THROTTLING_RATE_USER', '500/minute'),
    },
}

if DRF_SPECTACULAR_ON:
    SPECTACULAR_SETTINGS = {
        'TITLE': "Camp'n'go API",
        'DESCRIPTION': _('Application for camping management'),
        'VERSION': '1.0.0',
        'SERVE_INCLUDE_SCHEMA': False,
        'SWAGGER_UI_DIST': 'SIDECAR',
        'SWAGGER_UI_FAVICON_HREF': 'SIDECAR',
        'REDOC_DIST': 'SIDECAR',
    }

API_ERROR_MESSAGE = {'message': CommonErrorsEnum.ERROR.value}
API_MISSING_MESSAGE = {'message': CommonErrorsEnum.MISSING.value}

STANDARD_PAGINATION_PAGE_SIZE = int(os.getenv('STANDARD_PAGINATION_PAGE_SIZE', 5))
STANDARD_PAGINATION_MAX_PAGE_SIZE = int(os.getenv('STANDARD_PAGINATION_MAX_PAGE_SIZE', 100))
PAGINATION_PAGE_SIZE_QUERY_PARAM = os.getenv('STANDARD_PAGINATION_PAGE_SIZE', 'page_size')
