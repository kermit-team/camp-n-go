"""
This is a django-split-settings main file.

For more information read this:
https://github.com/sobolevn/django-split-settings

To change settings file:
`DJANGO_ENV=production python manage.py runserver`
"""

from os import environ

from split_settings.tools import include

# Managing environment via DJANGO_ENV variable:
environ.setdefault('DJANGO_ENV', 'production')
ENV = environ['DJANGO_ENV']

base_settings = [
    'components/apps.py',
    'components/camping.py',
    'components/common.py',
    'components/database.py',
    'components/logging.py',
    'components/mailing.py',
    'components/payment.py',
    'components/permissions.py',
    'components/queue.py',
    'components/rest.py',
    'components/security.py',
    'components/translations.py',
    'environments/{0}.py'.format(ENV),
]

# Include settings:
include(*base_settings)
