INSTALLED_APPS = [
    # Default django apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # 3rd party apps
    'cid.apps.CidAppConfig',
    'corsheaders',
    'django_filters',
    'phonenumber_field',
    'rest_framework',
    'rest_framework_simplejwt',

    # apps
    'server.apps.account',
    'server.apps.car',
    'server.apps.common',
]
