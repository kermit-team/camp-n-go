import os

from django.utils.translation import gettext_lazy as _

from server.settings.components.camping import DRF_SPECTACULAR_ON
from server.settings.components.common import DATETIME_INPUT_FORMATS

REST_FRAMEWORK = {
    'TEST_REQUEST_DEFAULT_FORMAT': 'json',
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
    ],
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': int(os.getenv('REST_PAGE_SIZE', 10)),
    'DATETIME_FORMAT': DATETIME_INPUT_FORMATS[0],
    'DATETIME_INPUT_FORMATS': DATETIME_INPUT_FORMATS,
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
