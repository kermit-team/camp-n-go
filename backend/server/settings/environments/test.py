ALLOWED_HOSTS = ('*',)
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
DEBUG = False
