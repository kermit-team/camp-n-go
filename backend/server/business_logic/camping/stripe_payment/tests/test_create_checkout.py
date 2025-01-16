import time
from datetime import date, timedelta
from unittest import mock

from django.conf import settings
from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.messages.stripe_payment import StripePaymentMessagesEnum
from server.apps.camping.models import CampingPlot, CampingSection
from server.business_logic.camping.stripe_payment import StripePaymentCreateCheckoutBL
from server.utils.tests.baker_generators import generate_password


class StripePaymentCreateCheckoutBLTestCase(TestCase):
    given_date = date(2020, 1, 1)
    date_from = given_date + timedelta(days=7)
    date_to = date_from + timedelta(days=7)

    number_of_adults = 2
    number_of_children = 1

    mock_stripe = 'server.business_logic.camping.stripe_payment.create_checkout.stripe'

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            max_number_of_people=self.number_of_adults + self.number_of_children,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    @freeze_time(given_date)
    @mock.patch(mock_stripe)
    @mock.patch.object(StripePaymentCreateCheckoutBL, '_create_checkout_items')
    def test_process(self, create_checkout_items_mock, stripe_mock):
        result = StripePaymentCreateCheckoutBL.process(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            camping_plot=self.camping_plot,
        )

        create_checkout_items_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            camping_plot=self.camping_plot,
        )
        stripe_mock.checkout.Session.create.assert_called_once_with(
            customer_email=self.account.email,
            line_items=create_checkout_items_mock.return_value,
            mode=settings.CHECKOUT_MODE,
            success_url=settings.CHECKOUT_SUCCESS_URL,
            cancel_url=settings.CHECKOUT_CANCEL_URL,
            expires_at=int(time.time() + settings.CHECKOUT_EXPIRATION),
        )

        assert result == stripe_mock.checkout.Session.create.return_value

    @mock.patch(mock_stripe)
    def test_create_checkout_items(self, stripe_mock):
        number_of_days = (self.date_to - self.date_from).days

        expected_result = [
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_BASE_PRICE_PRODUCT_NAME.value.format(
                            camping_section_name=self.camping_plot.camping_section.name,
                            camping_plot_position=self.camping_plot.position,
                            date_from=self.date_from,
                            date_to=self.date_to,
                        ),
                    },
                    'unit_amount': int(self.camping_plot.camping_section.base_price * number_of_days * 100),
                },
                'quantity': 1,
            },
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_ADULT_PRICE_PRODUCT_NAME.value,
                    },
                    'unit_amount': int(self.camping_plot.camping_section.price_per_adult * number_of_days * 100),
                },
                'quantity': self.number_of_adults,
            },
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_CHILD_PRICE_PRODUCT_NAME.value,
                    },
                    'unit_amount': int(self.camping_plot.camping_section.price_per_child * number_of_days * 100),
                },
                'quantity': self.number_of_children,
            },
        ]

        result = StripePaymentCreateCheckoutBL._create_checkout_items(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            camping_plot=self.camping_plot,
        )

        assert result == expected_result

    @mock.patch(mock_stripe)
    def test_create_checkout_items_when_no_children_in_reservation(self, stripe_mock):
        number_of_days = (self.date_to - self.date_from).days

        expected_result = [
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_BASE_PRICE_PRODUCT_NAME.value.format(
                            camping_section_name=self.camping_plot.camping_section.name,
                            camping_plot_position=self.camping_plot.position,
                            date_from=self.date_from,
                            date_to=self.date_to,
                        ),
                    },
                    'unit_amount': int(self.camping_plot.camping_section.base_price * number_of_days * 100),
                },
                'quantity': 1,
            },
            {
                'price_data': {
                    'currency': settings.CHECKOUT_CURRENCY,
                    'product_data': {
                        'name': StripePaymentMessagesEnum.CAMPING_PLOT_ADULT_PRICE_PRODUCT_NAME.value,
                    },
                    'unit_amount': int(self.camping_plot.camping_section.price_per_adult * number_of_days * 100),
                },
                'quantity': self.number_of_adults,
            },
        ]

        result = StripePaymentCreateCheckoutBL._create_checkout_items(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=0,
            camping_plot=self.camping_plot,
        )

        assert result == expected_result
