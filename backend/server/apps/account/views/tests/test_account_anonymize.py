import uuid
from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.messages.account import AccountMessagesEnum
from server.apps.account.models import Account, AccountProfile
from server.apps.account.views import AccountAnonymizeView
from server.business_logic.account import AccountAnonymizeBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AccountAnonymizeViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountAnonymizeView
        cls.viewname = 'account_anonymize'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountAnonymizeBL, 'process')
    def test_request(self, anonymize_account_mock):
        parameters = {'identifier': self.account.identifier}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {
            'message': AccountMessagesEnum.ANONYMIZATION_SUCCESS.value.format(identifier=self.account.identifier),
        }

        anonymize_account_mock.assert_called_once_with(account=self.account)
        assert res.status_code == status.HTTP_204_NO_CONTENT
        assert res.data == expected_data

    @mock.patch.object(AccountAnonymizeBL, 'process')
    def test_request_without_existing_account(self, anonymize_account_mock):
        parameters = {'identifier': uuid.uuid4()}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.delete(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        anonymize_account_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(AccountAnonymizeBL, 'process')
    def test_permissions(self, anonymize_account_mock):
        self._create_accounts_with_groups_and_permissions()

        account = baker.make(_model=Account)
        parameters = {'identifier': account.identifier}

        self._test_destroy_permissions(parameters=parameters)

    @mock.patch.object(AccountAnonymizeBL, 'process')
    def test_permissions_as_object_relation(self, anonymize_account_mock):
        self._create_accounts_with_groups_and_permissions()

        default_account = baker.make(_model=Account)
        accounts_with_view_permissions = (
            (None, False),
            (self._account, False),
            (self._owner, True),
            (self._employee, True),
            (self._client, True),
            (self._superuser, True),
        )

        for account, has_permissions in accounts_with_view_permissions:
            parameters = {'identifier': account.identifier if account else default_account.identifier}
            url = reverse(self.viewname, kwargs=parameters)

            request = self.factory.delete(url)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
