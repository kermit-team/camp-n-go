from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationListView
from server.datastore.queries.camping import ReservationQuery
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class ReservationListViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationListView
        cls.viewname = 'reservation_list'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
            client=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)

    def test_request(self):
        url = reverse(self.viewname)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'count': 1,
            'links': {
                'next': None,
                'previous': None,
            },
            'page': 1,
            'results': self.view.serializer_class(
                ReservationQuery.get_queryset_for_account(account=self.account),
                context={'request': req},
                many=True,
            ).data,
        }

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch('server.apps.camping.views.ReservationListView.pagination_class')
    def test_request_with_disabled_pagination(
        self,
        pagination_class_mock,
    ):
        pagination_class_mock.return_value = None
        url = reverse(self.viewname)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            ReservationQuery.get_queryset_for_account(account=self.account),
            context={'request': req},
            many=True,
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_permissions(self):
        Reservation.objects.all().delete()
        self._create_accounts_with_groups_and_permissions()

        self._test_list_permissions()
