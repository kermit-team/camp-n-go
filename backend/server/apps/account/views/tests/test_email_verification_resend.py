from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.views import AccountEmailVerificationResendView
from server.business_logic.account import AccountEmailVerificationResendBL


class AccountEmailVerificationResendViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountEmailVerificationResendView

    @mock.patch.object(AccountEmailVerificationResendBL, 'process')
    def test_request(self, account_email_verification_resend_mock):
        request_data = {'email': 'admin@example.com'}

        url = reverse('email_verification_resend')
        req = self.factory.post(url, data=request_data)

        res = self.view.as_view()(req)

        account_email_verification_resend_mock.assert_called_once_with(email=request_data['email'])

        assert res.status_code == status.HTTP_200_OK

    @mock.patch.object(AccountEmailVerificationResendBL, 'process')
    def test_request_invalid_data(self, account_email_verification_resend_mock):
        request_data = {'email': 'bad_email_example'}

        url = reverse('email_verification_resend')
        req = self.factory.post(url, data=request_data)

        res = self.view.as_view()(req)

        account_email_verification_resend_mock.assert_not_called()

        assert res.status_code == status.HTTP_400_BAD_REQUEST
