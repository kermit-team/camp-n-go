from datetime import date
from unittest import mock

from django.test import TestCase
from model_bakery import baker
from rest_framework.exceptions import ErrorDetail

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection
from server.apps.camping.serializers import ReservationCreateSerializer
from server.apps.car.models import Car
from server.apps.common.errors.common import CommonErrorMessagesEnum
from server.business_logic.camping import ReservationCreateBL
from server.utils.tests.baker_generators import generate_password


class ReservationCreateSerializerTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    number_of_adults = 2
    number_of_children = 1

    comments = 'Some comments'

    mock_stripe = 'server.apps.camping.serializers.reservation_create.stripe'

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            max_number_of_people=self.number_of_adults + self.number_of_children,
            camping_section=self.camping_section,
            _fill_optional=True,
        )
        self.request = mock.MagicMock(user=self.account)

    @mock.patch(mock_stripe)
    @mock.patch.object(ReservationCreateBL, 'process')
    def test_create(self, create_reservation_mock, stripe_mock):
        serializer = ReservationCreateSerializer(
            data={
                'date_from': self.date_from,
                'date_to': self.date_to,
                'number_of_adults': self.number_of_adults,
                'number_of_children': self.number_of_children,
                'car': self.car.id,
                'camping_plot': self.camping_plot.id,
                'comments': self.comments,
            },
            context={'request': self.request},
        )
        assert serializer.is_valid()
        serializer.save()

        create_reservation_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.request.user,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=self.comments,
        )

        serializer_data = serializer.data

        stripe_mock.checkout.Session.retrieve.assert_called_once_with(
            id=create_reservation_mock.return_value.payment.stripe_checkout_id,
        )
        assert serializer_data['checkout_url'] == stripe_mock.checkout.Session.retrieve.return_value.url

    @mock.patch(mock_stripe)
    @mock.patch.object(ReservationCreateBL, 'process')
    def test_create_without_optional_fields(self, create_reservation_mock, stripe_mock):
        serializer = ReservationCreateSerializer(
            data={
                'date_from': self.date_from,
                'date_to': self.date_to,
                'number_of_adults': self.number_of_adults,
                'number_of_children': self.number_of_children,
                'car': self.car.id,
                'camping_plot': self.camping_plot.id,
            },
            context={'request': self.request},
        )
        assert serializer.is_valid()
        serializer.save()

        create_reservation_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.request.user,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=None,
        )

        serializer_data = serializer.data

        stripe_mock.checkout.Session.retrieve.assert_called_once_with(
            id=create_reservation_mock.return_value.payment.stripe_checkout_id,
        )
        assert serializer_data['checkout_url'] == stripe_mock.checkout.Session.retrieve.return_value.url

    @mock.patch(mock_stripe)
    def test_validate(self, stripe_mock):
        serializer = ReservationCreateSerializer(
            data={
                'date_from': self.date_from,
                'date_to': self.date_to,
                'number_of_adults': self.number_of_adults,
                'number_of_children': self.number_of_children,
                'comments': self.comments,
                'car': self.car.id,
                'camping_plot': self.camping_plot.id,
            },
            context={'request': self.request},
        )
        assert serializer.is_valid()

    @mock.patch(mock_stripe)
    def test_validate_invalid_date_values(self, stripe_mock):
        expected_errors = [
            ErrorDetail(
                string=CommonErrorMessagesEnum.INVALID_DATE_VALUES.value.format(
                    date_from=self.date_to,
                    date_to=self.date_from,
                ),
                code='invalid',
            ),
        ]

        serializer = ReservationCreateSerializer(
            data={
                'date_from': self.date_to,
                'date_to': self.date_from,
                'number_of_adults': self.number_of_adults,
                'number_of_children': self.number_of_children,
                'comments': self.comments,
                'car': self.car.id,
                'camping_plot': self.camping_plot.id,
            },
            context={'request': self.request},
        )

        assert not serializer.is_valid()
        self.assertCountEqual(serializer.errors['non_field_errors'], expected_errors)
