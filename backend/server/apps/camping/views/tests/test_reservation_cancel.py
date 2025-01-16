from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.messages.reservation import ReservationMessagesEnum
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationCancelView
from server.business_logic.camping import ReservationCancelBL


class ReservationCancelViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationCancelView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_request(self, cancel_reservation_mock):
        parameters = {
            'pk': self.reservation.id,
        }
        url = reverse('reservation_cancel', kwargs=parameters)

        req = self.factory.patch(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {
            'message': ReservationMessagesEnum.CANCELLATION_SUCCESS.value,
        }

        cancel_reservation_mock.assert_called_once_with(reservation=self.reservation)
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_request_without_existing_reservation(self, cancel_reservation_mock):
        parameters = {
            'pk': 0,
        }
        url = reverse('reservation_cancel', kwargs=parameters)

        req = self.factory.patch(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        cancel_reservation_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
