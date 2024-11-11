import django

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

# Django must be setup before model bakery can access any Model
django.setup()

# isort: split

from model_bakery import baker  # noqa: E402

baker.generators.add('phonenumber_field.modelfields.PhoneNumberField', generate_phone_number)
