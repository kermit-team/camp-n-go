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

MAX_REFUND_TIME = int(os.getenv('MAX_REFUND_TIME_IN_DAYS', 14))
CONTACT_FORM_RESPOND_TIME = int(os.getenv('CONTACT_FORM_RESPOND_TIME_IN_DAYS', 1))
RESERVATIONS_REMINDER_DISPATCH_TIME = int(os.getenv('RESERVATIONS_REMINDER_DISPATCH_TIME_IN_DAYS', 1))
