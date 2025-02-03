import logging

import django

from server.settings.components.logging import LOGGING
from server.settings.components.rest import REST_FRAMEWORK
from server.utils.tests.baker_generators import generate_phone_number

ALLOWED_HOSTS = ('*',)
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
DEBUG = False

DJANGO_SILK_ON = 0
DRF_SPECTACULAR_ON = 0

LOGGING['loggers']['']['level'] = logging.DEBUG
LOGGING['loggers']['django']['level'] = logging.DEBUG
LOGGING['loggers']['security']['level'] = logging.DEBUG
LOGGING['loggers']['server.utils.api.exception_handler']['level'] = logging.DEBUG
LOGGING['loggers']['celery']['level'] = logging.DEBUG

REST_FRAMEWORK['TEST_REQUEST_DEFAULT_FORMAT'] = 'json'

# Django must be setup before model bakery can access any Model
django.setup()

# isort: split

from model_bakery import baker  # noqa: E402

baker.generators.add('phonenumber_field.modelfields.PhoneNumberField', generate_phone_number)
