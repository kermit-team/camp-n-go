from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.views import AccountEmailVerificationView
from server.business_logic.account.email_verification import AccountEmailVerificationBL


class AccountEmailVerificationViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountEmailVerificationView

    @mock.patch.object(AccountEmailVerificationBL, 'process')
    def test_request(self, account_email_verification_mock):
        uidb64 = 'some_encoded_uidb64'
        token = 'some_token'
        parameters = {'uidb64': uidb64, 'token': token}

        url = reverse(
            'account_email_verification',
            kwargs=parameters,
        )
        req = self.factory.get(url)

        res = self.view.as_view()(req, **parameters)

        account_email_verification_mock.assert_called_once_with(
            uidb64=uidb64,
            token=token,
        )

        assert res.status_code == status.HTTP_200_OK
