import os

from server.settings.components.apps import INSTALLED_APPS
from server.settings.components.camping import DJANGO_SILK_ON, DRF_SPECTACULAR_ON
from server.settings.components.common import BASE_DIR, MIDDLEWARE

ALLOWED_HOSTS = ('*',)
CSRF_TRUSTED_ORIGINS = os.getenv('CSRF_TRUSTED_ORIGINS', 'http://localhost http://127.0.0.1').split(' ')
CORS_ALLOW_ALL_ORIGINS = True
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'server', 'static')

if DJANGO_SILK_ON:
    MIDDLEWARE += ['silk.middleware.SilkyMiddleware']
    INSTALLED_APPS += ['silk']

if DRF_SPECTACULAR_ON:
    INSTALLED_APPS += [
        'drf_spectacular',
        'drf_spectacular_sidecar',
    ]
