from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.views import AccountPasswordResetConfirmView
from server.business_logic.account import AccountPasswordResetConfirmBL


class AccountPasswordResetConfirmViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountPasswordResetConfirmView

        cls.uidb64 = 'some_encoded_uidb64'
        cls.token = 'some_token'

    @mock.patch.object(AccountPasswordResetConfirmBL, 'process')
    def test_request(self, account_password_reset_confirm_mock):
        password = 'Q@werty123!'
        parameters = {'uidb64': self.uidb64, 'token': self.token}
        request_data = {'password': password}

        url = reverse(
            'password_reset_confirm',
            kwargs=parameters,
        )
        req = self.factory.post(url, data=request_data)

        res = self.view.as_view()(req, **parameters)

        account_password_reset_confirm_mock.assert_called_once_with(
            uidb64=self.uidb64,
            token=self.token,
            password=password,
        )

        assert res.status_code == status.HTTP_200_OK

    @mock.patch.object(AccountPasswordResetConfirmBL, 'process')
    def test_request_invalid_data(self, account_password_reset_confirm_mock):
        password = 'bad_password'
        parameters = {'uidb64': self.uidb64, 'token': self.token}
        request_data = {'password': password}

        url = reverse(
            'password_reset_confirm',
            kwargs=parameters,
        )
        req = self.factory.post(url, data=request_data)

        res = self.view.as_view()(req, **parameters)

        account_password_reset_confirm_mock.assert_not_called()

        assert res.status_code == status.HTTP_400_BAD_REQUEST
