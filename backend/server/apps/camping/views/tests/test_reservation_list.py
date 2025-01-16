from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
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
        url = reverse('camping_plot_availability_list')

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
