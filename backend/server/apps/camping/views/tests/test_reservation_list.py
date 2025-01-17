from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationListView


class ReservationListViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationListView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch('server.apps.camping.views.ReservationListView.get_queryset')
    def test_request(self, mock_get_reservation_list_queryset):
        queryset = self.view.queryset.all()
        mock_get_reservation_list_queryset.return_value = queryset

        url = reverse('reservation_list')

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'count': mock_get_reservation_list_queryset.return_value.count(),
            'links': {
                'next': None,
                'previous': None,
            },
            'page': 1,
            'results': self.view.serializer_class(
                queryset,
                context={'request': req},
                many=True,
            ).data,
        }

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch('server.apps.camping.views.ReservationListView.get_queryset')
    @mock.patch('server.apps.camping.views.ReservationListView.pagination_class')
    def test_request_with_disabled_pagination(
        self,
        mock_pagination_class,
        mock_get_reservation_list_queryset,
    ):
        queryset = self.view.queryset.all()
        mock_pagination_class.return_value = None
        mock_get_reservation_list_queryset.return_value = queryset
        url = reverse('reservation_list')

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            queryset,
            context={'request': req},
            many=True,
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_get_queryset(self):
        user_reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)
        another_reservation = baker.make(_model=Reservation, _fill_optional=True)

        url = reverse('reservation_list')

        req = self.factory.get(url)
        req.user = self.account

        view = self.view()
        view.request = req

        queryset = view.get_queryset()

        assert queryset.count() == 1
        assert user_reservation in set(queryset)
        assert another_reservation not in set(queryset)
