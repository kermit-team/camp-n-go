import os
from decimal import Decimal

# Predefined char lengths
MICRO_LENGTH = 8
TINY_LENGTH = 16
SMALL_LENGTH = 32
MEDIUM_LENGTH = 64
INTERMEDIATE_LENGTH = 128
LARGE_LENGTH = 256
XL_LENGTH = 512
XXL_LENGTH = 1024

PLOT_PRICE_DIGITS = 6
PRICE_DECIMAL_PLACES = 2
PRICE_MIN_VALUE = Decimal('0')

RESERVATION_PRICE_DIGITS = 8

PLOT_SIZE_DIGITS = 5
PLOT_SIZE_DECIMAL_PLACES = 2
PLOT_SIZE_MIN_VALUE = Decimal('0.01')

RESERVATION_CANCELLATION_PERIOD = int(os.getenv('RESERVATION_CANCELLATION_PERIOD_IN_DAYS', 7))

DJANGO_SILK_ON = bool(int(os.getenv('DJANGO_SILK_ON', 0)))
DRF_SPECTACULAR_ON = bool(int(os.getenv('DRF_SPECTACULAR_ON', 0)))

AVATAR_DEFAULT_IMAGE = 'avatar.png'
AVATARS_SUBDIRECTORY = 'account/avatars/'

FRONTEND_DOMAIN = os.getenv('FRONTEND_DOMAIN')
if FRONTEND_DOMAIN.endswith('/'):
    FRONTEND_DOMAIN = FRONTEND_DOMAIN[:-1]

DAY_IN_SECONDS = 86400
HOUR_IN_SECONDS = 3600
MINUTE_IN_SECONDS = 60

CHECK_IN_TIME = int(os.getenv('CHECK_IN_TIME_AS_HOUR', 14))
CHECK_OUT_TIME = int(os.getenv('CHECK_OUT_TIME_AS_HOUR', 10))
