import os
from types import MappingProxyType

EMAIL_BACKEND_MAPPING: MappingProxyType[str, str] = MappingProxyType(
    {
        'SMTP': 'django.core.mail.backends.smtp.EmailBackend',
        'CONSOLE': 'django.core.mail.backends.console.EmailBackend',
        'FILE': 'django.core.mail.backends.filebased.EmailBackend',
        'IN_MEMORY': 'django.core.mail.backends.locmem.EmailBackend',
        'DUMMY': 'django.core.mail.backends.dummy.EmailBackend',
    },
)

EMAIL_BACKEND = EMAIL_BACKEND_MAPPING[os.getenv('EMAIL_BACKEND', 'CONSOLE')]
EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD')
EMAIL_HOST = os.getenv('EMAIL_HOST')
EMAIL_PORT = os.getenv('EMAIL_PORT')

FRONTEND_DOMAIN = os.getenv('FRONTEND_DOMAIN')
if FRONTEND_DOMAIN.endswith('/'):
    FRONTEND_DOMAIN = FRONTEND_DOMAIN[:-1]
