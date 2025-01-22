from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views.admin import AdminReservationListView
from server.datastore.queries.camping import ReservationQuery


class AdminReservationListViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminReservationListView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    @mock.patch.object(ReservationQuery, 'get_queryset')
    def test_request(self, get_queryset_mock, get_with_matching_reservation_data_mock):
        queryset = Reservation.objects.order_by('id')
        get_queryset_mock.return_value = queryset
        get_with_matching_reservation_data_mock.return_value = queryset

        url = reverse('admin_reservation_list')

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'count': get_queryset_mock.return_value.count(),
            'links': {
                'next': None,
                'previous': None,
            },
            'page': 1,
            'results': self.view.serializer_class(
                get_queryset_mock.return_value,
                context={'request': req},
                many=True,
            ).data,
        }

        get_queryset_mock.assert_called_once_with()
        get_with_matching_reservation_data_mock.assert_not_called()

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    @mock.patch.object(ReservationQuery, 'get_queryset')
    @mock.patch('server.apps.camping.views.admin.AdminReservationListView.pagination_class')
    def test_request_with_disabled_pagination(
        self,
        pagination_class_mock,
        get_queryset_mock,
        get_with_matching_reservation_data_mock,
    ):
        queryset = Reservation.objects.order_by('id')
        get_queryset_mock.return_value = queryset
        get_with_matching_reservation_data_mock.return_value = queryset
        pagination_class_mock.return_value = None

        url = reverse('admin_reservation_list')

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            get_queryset_mock.return_value,
            context={'request': req},
            many=True,
        ).data

        get_queryset_mock.assert_called_once_with()
        get_with_matching_reservation_data_mock.assert_not_called()

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data
