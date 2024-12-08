from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views import AccountRegisterView
from server.business_logic.account import AccountRegisterBL
from server.utils.tests.baker_generators import generate_password


class AccountRegisterViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountRegisterView

    def setUp(self):
        self.account = baker.prepare(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountRegisterBL, 'process')
    def test_request(self, register_account_mock):
        request_data = {
            'email': self.account.email,
            'password': self.account.password,
            'profile': {
                'first_name': self.account_profile.first_name,
                'last_name': self.account_profile.last_name,
            },
        }
        url = reverse('register')

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        expected_data = {
            'email': str(register_account_mock.return_value.email),
            'profile': {
                'first_name': str(register_account_mock.return_value.profile.first_name),
                'last_name': str(register_account_mock.return_value.profile.last_name),
                'phone_number': str(register_account_mock.return_value.profile.phone_number),
                'avatar': register_account_mock.return_value.profile.avatar.url,
                'id_card': str(register_account_mock.return_value.profile.id_card),
            },
        }

        register_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )

        assert res.status_code == status.HTTP_201_CREATED
        assert res.data == expected_data
