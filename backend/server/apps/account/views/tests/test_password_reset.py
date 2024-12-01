from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.messages import AccountMessagesEnum
from server.apps.account.views import AccountPasswordResetView
from server.business_logic.account import AccountPasswordResetBL


class AccountPasswordResetViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountPasswordResetView

    @mock.patch.object(AccountPasswordResetBL, 'process')
    def test_request(self, account_password_reset_mock):
        request_data = {'email': 'admin@example.com'}
        url = reverse('password_reset')
        expected_message = {
            'message': AccountMessagesEnum.PASSWORD_RESET_SUCCESS.value.format(email=request_data['email']),
        }

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        account_password_reset_mock.assert_called_once_with(email=request_data['email'])
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_message
