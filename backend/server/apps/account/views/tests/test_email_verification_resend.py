from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.messages.account import AccountMessagesEnum
from server.apps.account.views import AccountEmailVerificationResendView
from server.business_logic.account import AccountEmailVerificationResendBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class AccountEmailVerificationResendViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountEmailVerificationResendView
        cls.viewname = 'account_email_verification_resend'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

    @mock.patch.object(AccountEmailVerificationResendBL, 'process')
    def test_request(self, account_email_verification_resend_mock):
        request_data = {'email': 'admin@example.com'}
        url = reverse(self.viewname)
        expected_message = {
            'message': AccountMessagesEnum.EMAIL_VERIFICATION_RESEND_SUCCESS.value.format(email=request_data['email']),
        }

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        account_email_verification_resend_mock.assert_called_once_with(email=request_data['email'])
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_message

    @mock.patch.object(AccountEmailVerificationResendBL, 'process')
    def test_permissions(self, account_email_verification_resend_mock):
        self._create_accounts_with_groups_and_permissions()
        request_data = {'email': 'admin@example.com'}

        self._test_custom_view_permissions(request_factory_handler=self.factory.post, data=request_data)
