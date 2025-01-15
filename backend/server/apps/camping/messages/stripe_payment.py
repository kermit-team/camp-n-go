from enum import Enum

from django.utils.translation import gettext_lazy as _


class StripePaymentMessagesEnum(Enum):
    EVENT_SUCCESS = _('Stripe event {event_id} was handled successfully.')
    CAMPING_PLOT_BASE_PRICE_PRODUCT_NAME = _(
        'Camping plot {camping_section_name}_{camping_plot_position} reservation fee on date {date_from} - {date_to}',
    )
    CAMPING_PLOT_ADULT_PRICE_PRODUCT_NAME = _('Adult fee')
    CAMPING_PLOT_CHILD_PRICE_PRODUCT_NAME = _('Child fee')
    PAYMENT_STATUS_CHANGED = 'Payment {stripe_checkout_id} status was set to {status}.'
