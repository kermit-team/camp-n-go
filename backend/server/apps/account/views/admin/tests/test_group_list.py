from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views.admin import AdminGroupListView
from server.datastore.queries.account import GroupQuery
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AdminGroupListViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminGroupListView
        cls.viewname = 'admin_group_list'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    def test_request(self):
        url = reverse(self.viewname)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            GroupQuery.get_queryset(),
            context={'request': req},
            many=True,
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_permissions(self):
        self._create_accounts_with_groups_and_permissions()
        self._test_list_permissions()
