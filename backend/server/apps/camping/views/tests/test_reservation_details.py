from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationDetailsView


class ReservationDetailsViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationDetailsView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.reservation = baker.make(_model=Reservation, _fill_optional=True)

    def test_request(self):
        parameters = {
            'pk': self.reservation.id,
        }
        url = reverse('reservation_details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=self.reservation,
            context={'request': req},
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_request_without_existing_reservation(self):
        parameters = {
            'pk': 0,
        }
        url = reverse('reservation_details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
