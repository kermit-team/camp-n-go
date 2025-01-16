import os

from server.settings.components.camping import FRONTEND_DOMAIN

STRIPE_API_KEY = os.getenv('STRIPE_API_KEY')
STRIPE_WEBHOOK_SIGNING_SECRET = os.getenv('STRIPE_WEBHOOK_SIGNING_SECRET')

CHECKOUT_CURRENCY = 'pln'
CHECKOUT_MODE = 'payment'
CHECKOUT_SUCCESS_URL = '/'.join([FRONTEND_DOMAIN, os.getenv('CHECKOUT_SUCCESS_URL')])
CHECKOUT_CANCEL_URL = '/'.join([FRONTEND_DOMAIN, os.getenv('CHECKOUT_CANCEL_URL')])
CHECKOUT_EXPIRATION = int(os.getenv('CHECKOUT_EXPIRATION_IN_SECONDS', 3600))

MAX_REFUND_TIME = 14
