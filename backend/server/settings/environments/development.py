import os

from server.settings.components.apps import INSTALLED_APPS
from server.settings.components.common import BASE_DIR, MIDDLEWARE
from server.settings.components.database import DJANGO_SILK_ON

ALLOWED_HOSTS = ('*',)
CSRF_TRUSTED_ORIGINS = os.getenv('CSRF_TRUSTED_ORIGINS', 'http://localhost http://127.0.0.1').split(' ')
CORS_ALLOW_ALL_ORIGINS = True
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

if DJANGO_SILK_ON:
    MIDDLEWARE += ['silk.middleware.SilkyMiddleware']
    INSTALLED_APPS += ['silk']
