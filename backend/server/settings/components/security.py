import datetime
import os

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('SECRET_KEY')

AUTH_USER_MODEL = 'account.Account'

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
    {
        'NAME': 'server.apps.account.validators.password.LowercaseValidator',
    },
    {
        'NAME': 'server.apps.account.validators.password.SpecialCharacterValidator',
    },
    {
        'NAME': 'server.apps.account.validators.password.UppercaseValidator',
    },
]

PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.Argon2PasswordHasher',
    'django.contrib.auth.hashers.PBKDF2PasswordHasher',
    'django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher',
    'django.contrib.auth.hashers.BCryptSHA256PasswordHasher',
]

CORS_ALLOW_CREDENTIALS = True

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': datetime.timedelta(
        seconds=int(os.getenv('ACCESS_TOKEN_LIFETIME_IN_SECONDS', 60 * 30)),
    ),
    'REFRESH_TOKEN_LIFETIME': datetime.timedelta(
        seconds=int(os.getenv('REFRESH_TOKEN_LIFETIME_IN_SECONDS', 60 * 60 * 24)),
    ),
    'USER_ID_FIELD': 'identifier',
    'USER_ID_CLAIM': 'user_identifier',
}


PASSWORD_RESET_TIMEOUT = int(os.getenv('PASSWORD_RESET_TIMEOUT_IN_SECONDS', 60 * 60 * 24))
