import os

from django.utils.translation import gettext_lazy as _

from server.settings.components.common import BASE_DIR

LANGUAGE_CODE = 'pl-PL'

TIME_ZONE = 'Europe/Warsaw'

USE_I18N = True

USE_L10N = True

USE_TZ = True

LANGUAGES = [
    ('pl', _('Polish')),
]

LOCALE_PATHS = [
    os.path.join(BASE_DIR, 'server', 'locale'),
]
