from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.messages.account import AccountMessagesEnum
from server.apps.account.views import AccountEmailVerificationView
from server.business_logic.account import AccountEmailVerificationBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AccountEmailVerificationViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountEmailVerificationView
        cls.viewname = 'account_email_verification'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

        cls.uidb64 = 'some_encoded_uidb64'
        cls.token = 'some_token'

    @mock.patch.object(AccountEmailVerificationBL, 'process')
    def test_request(self, account_email_verification_mock):
        parameters = {'uidb64': self.uidb64, 'token': self.token}
        url = reverse(self.viewname, kwargs=parameters)
        expected_message = {
            'message': AccountMessagesEnum.EMAIL_VERIFICATION_SUCCESS.value.format(uidb64=parameters['uidb64']),
        }

        req = self.factory.get(url)
        res = self.view.as_view()(req, **parameters)

        account_email_verification_mock.assert_called_once_with(
            uidb64=self.uidb64,
            token=self.token,
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_message

    @mock.patch.object(AccountEmailVerificationBL, 'process')
    def test_permissions(self, account_email_verification_mock):
        self._create_accounts_with_groups_and_permissions()
        parameters = {'uidb64': self.uidb64, 'token': self.token}

        self._test_custom_view_permissions(request_factory_handler=self.factory.get, parameters=parameters)
