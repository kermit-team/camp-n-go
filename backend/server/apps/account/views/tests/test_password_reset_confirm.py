from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.messages.account import AccountMessagesEnum
from server.apps.account.views import AccountPasswordResetConfirmView
from server.business_logic.account import AccountPasswordResetConfirmBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin
from server.utils.tests.baker_generators import generate_password


class AccountPasswordResetConfirmViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountPasswordResetConfirmView
        cls.viewname = 'account_password_reset_confirm'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

        cls.uidb64 = 'some_encoded_uidb64'
        cls.token = 'some_token'

    @mock.patch.object(AccountPasswordResetConfirmBL, 'process')
    def test_request(self, account_password_reset_confirm_mock):
        parameters = {'uidb64': self.uidb64, 'token': self.token}
        password = generate_password()
        request_data = {'password': password}
        url = reverse(self.viewname, kwargs=parameters)
        expected_message = {
            'message': AccountMessagesEnum.PASSWORD_RESET_CONFIRM_SUCCESS.value.format(uidb64=parameters['uidb64']),
        }

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req, **parameters)

        account_password_reset_confirm_mock.assert_called_once_with(
            uidb64=self.uidb64,
            token=self.token,
            password=password,
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_message

    @mock.patch.object(AccountPasswordResetConfirmBL, 'process')
    def test_permissions(self, account_password_reset_confirm_mock):
        self._create_accounts_with_groups_and_permissions()
        password = generate_password()
        request_data = {'password': password}
        parameters = {'uidb64': self.uidb64, 'token': self.token}

        self._test_custom_view_permissions(
            request_factory_handler=self.factory.post,
            parameters=parameters,
            data=request_data,
        )
