from datetime import date
from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection, Reservation
from server.apps.camping.views import ReservationCreateView
from server.apps.car.models import Car
from server.business_logic.camping import ReservationCreateBL
from server.utils.tests.baker_generators import generate_password


class ReservationCreateViewTestCase(APITestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    number_of_adults = 2
    number_of_children = 1

    comments = 'Some comments'

    mock_stripe = 'server.apps.camping.serializers.reservation_create.stripe'

    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationCreateView

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            max_number_of_people=self.number_of_adults + self.number_of_children,
            camping_section=self.camping_section,
            _fill_optional=True,
        )
        self.reservation = baker.make(
            _model=Reservation,
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=self.comments,
        )

    @mock.patch(mock_stripe)
    @mock.patch.object(ReservationCreateBL, 'process')
    def test_request(self, create_reservation_mock, stripe_mock):
        create_reservation_mock.return_value = self.reservation

        request_data = {
            'date_from': self.date_from,
            'date_to': self.date_to,
            'number_of_adults': self.number_of_adults,
            'number_of_children': self.number_of_children,
            'car': self.car.id,
            'camping_plot': self.camping_plot.id,
            'comments': self.comments,
        }
        url = reverse('reservation_create')

        req = self.factory.post(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'id': self.reservation.id,
            'date_from': self.reservation.date_from.isoformat(),
            'date_to': self.reservation.date_to.isoformat(),
            'number_of_adults': self.reservation.number_of_adults,
            'number_of_children': self.reservation.number_of_children,
            'car': self.reservation.car.pk,
            'camping_plot': self.reservation.camping_plot.pk,
            'comments': self.reservation.comments,
            'checkout_url': stripe_mock.checkout.Session.retrieve.return_value.url,
        }

        stripe_mock.checkout.Session.retrieve.assert_called_once_with(
            id=self.reservation.payment.stripe_checkout_id,
        )
        create_reservation_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=self.comments,
        )

        assert res.status_code == status.HTTP_201_CREATED
        assert res.data == expected_data
