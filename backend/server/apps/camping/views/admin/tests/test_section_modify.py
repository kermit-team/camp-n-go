from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingSection
from server.apps.camping.views.admin import AdminCampingSectionModifyView
from server.datastore.commands.camping import CampingSectionCommand
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AdminCampingSectionModifyViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AdminCampingSectionModifyView
        cls.viewname = 'admin_camping_section_modify'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.new_camping_section_data = baker.prepare(_model=CampingSection, _fill_optional=True)

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_request_put(self, modify_camping_section_mock):
        modify_camping_section_mock.return_value = self.camping_section
        request_data = {
            'base_price': self.new_camping_section_data.base_price,
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }
        parameters = {'pk': self.camping_section.id}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_camping_section_mock.return_value,
            context={'request': req},
        ).data

        modify_camping_section_mock.assert_called_once_with(
            camping_section=self.camping_section,
            base_price=request_data['base_price'],
            price_per_adult=request_data['price_per_adult'],
            price_per_child=request_data['price_per_child'],
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_request_put_without_existing_camping_section(self, modify_camping_section_mock):
        request_data = {
            'base_price': self.new_camping_section_data.base_price,
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }
        parameters = {'pk': 0}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_camping_section_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_request_patch(self, modify_camping_section_mock):
        modify_camping_section_mock.return_value = self.camping_section
        request_data = {
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }
        parameters = {'pk': self.camping_section.id}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_camping_section_mock.return_value,
            context={'request': req},
        ).data

        modify_camping_section_mock.assert_called_once_with(
            camping_section=self.camping_section,
            price_per_adult=request_data['price_per_adult'],
            price_per_child=request_data['price_per_child'],
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_request_patch_without_existing_account(self, modify_camping_section_mock):
        request_data = {
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }
        parameters = {'pk': 0}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_camping_section_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_permissions(self, modify_camping_section_mock):
        modify_camping_section_mock.return_value = self.camping_section

        self._create_accounts_with_groups_and_permissions()

        parameters = {'pk': self.camping_section.id}
        put_request_data = {
            'base_price': self.new_camping_section_data.base_price,
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }
        patch_request_data = {
            'price_per_adult': self.new_camping_section_data.price_per_adult,
            'price_per_child': self.new_camping_section_data.price_per_child,
        }

        self._test_update_permissions(parameters=parameters, data=put_request_data)
        self._test_partial_update_permissions(parameters=parameters, data=patch_request_data)
