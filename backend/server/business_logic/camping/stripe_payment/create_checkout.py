import time
from datetime import date

import stripe
from django.conf import settings

from server.apps.account.models import Account
from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.apps.camping.models import CampingPlot
from server.business_logic.abstract import AbstractBL


class StripePaymentCreateCheckoutBL(AbstractBL):
    stripe.api_key = settings.STRIPE_API_KEY

    @classmethod
    def process(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        user: Account,
        camping_plot: CampingPlot,
    ) -> stripe.checkout.Session:
        checkout_items = cls._create_checkout_items(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            camping_plot=camping_plot,
        )

        return stripe.checkout.Session.create(
            customer_email=user.email,
            line_items=checkout_items,
            mode=settings.CHECKOUT_MODE,
            success_url=settings.CHECKOUT_SUCCESS_URL,
            cancel_url=settings.CHECKOUT_CANCEL_URL,
            expires_at=int(time.time() + settings.CHECKOUT_EXPIRATION),
        )

    @classmethod
    def _create_checkout_items(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        camping_plot: CampingPlot,
    ) -> list[dict]:
        number_of_days = (date_to - date_from).days
        checkout_items = [
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_BASE_PRICE_PRODUCT_NAME.value.format(
                            camping_section_name=camping_plot.camping_section.name,
                            camping_plot_position=camping_plot.position,
                            date_from=date_from,
                            date_to=date_to,
                        ),
                    },
                    'unit_amount': int(camping_plot.camping_section.base_price * number_of_days * 100),
                },
                'quantity': 1,
            },
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_ADULT_PRICE_PRODUCT_NAME.value,
                    },
                    'unit_amount': int(camping_plot.camping_section.price_per_adult * number_of_days * 100),
                },
                'quantity': number_of_adults,
            },
        ]

        if number_of_children > 0:
            checkout_items.append({
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_CHILD_PRICE_PRODUCT_NAME.value,
                    },
                    'unit_amount': int(camping_plot.camping_section.price_per_child * number_of_days * 100),
                },
                'quantity': number_of_children,
            })
        return checkout_items
