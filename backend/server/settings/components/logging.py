import os
import secrets
import string

SIMPLE_FORMAT = '%(asctime)s logger=%(name)s :: %(levelname)s :: %(message)s'
DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'

DEFAULT_LOGGER_LEVEL = os.getenv('DEFAULT_LOGGER_LEVEL')
DJANGO_LOGGER_LEVEL = os.getenv('DJANGO_LOGGER_LEVEL', DEFAULT_LOGGER_LEVEL)
SECURITY_LOGGER_LEVEL = os.getenv('SECURITY_LOGGER_LEVEL', DEFAULT_LOGGER_LEVEL)
EXCEPTION_HANDLER_LOGGER_LEVEL = os.getenv('EXCEPTION_HANDLER_LOGGER_LEVEL', DEFAULT_LOGGER_LEVEL)
CELERY_LOGGER_LEVEL = os.getenv('CELERY_LOGGER_LEVEL', DEFAULT_LOGGER_LEVEL)

LOG_HANDLERS = os.getenv('LOG_HANDLERS', 'console').split()

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': (
                '%(asctime)s logger=%(name)s :: '
                '[%(process)d] :: '
                '%(levelname)s :: '
                'pathname=%(pathname)s lineno=%(lineno)s funcname=%(funcName)s %(message)s'
            ),
            'datefmt': DATETIME_FORMAT,
        },
        'simple': {
            'format': SIMPLE_FORMAT,
            'datefmt': DATETIME_FORMAT,
        },
        'api-error': {
            'format': '[cid: %(cid)s] %(asctime)s logger=%(name)s :: %(levelname)s :: %(message)s',
            'datefmt': DATETIME_FORMAT,
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
        'console-verbose': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'console-error': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'api-error',
        },
    },
    'filters': {
        'correlation': {
            '()': 'cid.log.CidContextFilter',
        },
    },
    'loggers': {
        '': {
            'handlers': LOG_HANDLERS,
            'level': DEFAULT_LOGGER_LEVEL,
            'propagate': False,
        },
        'django': {
            'handlers': LOG_HANDLERS,
            'level': DJANGO_LOGGER_LEVEL,
            'propagate': False,
        },
        'security': {
            'handlers': LOG_HANDLERS,
            'level': SECURITY_LOGGER_LEVEL,
            'propagate': False,
        },
        'server.utils.api.exception_handler': {
            'handlers': ['console-error'],
            'level': EXCEPTION_HANDLER_LOGGER_LEVEL,
            'filters': ['correlation'],
            'propagate': True,
        },
        'celery': {
            'handlers': LOG_HANDLERS,
            'level': CELERY_LOGGER_LEVEL,
            'propagate': False,
        },
    },
}

# Django CID configuration
CID_GENERATE = True
CID_CHARACTERS = string.ascii_letters + string.digits
CID_LENGTH = 6
CID_GENERATOR = lambda: ''.join(  # noqa: E731
    secrets.choice(CID_CHARACTERS) for _ in range(CID_LENGTH)
)
