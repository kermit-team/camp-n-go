from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingSection
from server.apps.camping.views.admin.section_list import AdminCampingSectionListView
from server.datastore.queries.camping import CampingSectionQuery
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AdminCampingSectionListViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminCampingSectionListView
        cls.viewname = 'admin_camping_section_list'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(CampingSectionQuery, 'get_queryset')
    def test_request(self, get_queryset_mock):
        queryset = CampingSection.objects.order_by('name')
        get_queryset_mock.return_value = queryset

        url = reverse(self.viewname)

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

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingSectionQuery, 'get_queryset')
    @mock.patch('server.apps.camping.views.admin.AdminCampingSectionListView.pagination_class')
    def test_request_with_disabled_pagination(self, pagination_class_mock, get_queryset_mock):
        queryset = CampingSection.objects.order_by('name')
        get_queryset_mock.return_value = queryset
        pagination_class_mock.return_value = None

        url = reverse(self.viewname)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            get_queryset_mock.return_value,
            context={'request': req},
            many=True,
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingSectionQuery, 'get_queryset')
    def test_permissions(self, get_queryset_mock):
        queryset = CampingSection.objects.order_by('name')
        get_queryset_mock.return_value = queryset

        self._create_accounts_with_groups_and_permissions()
        self._test_list_permissions()
