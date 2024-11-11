from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.account.serializers import AccountRegisterSerializer
from server.business_logic.account.register import RegisterAccountBL


class AccountRegisterSerializerTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(RegisterAccountBL, 'process')
    def test_create(self, register_account_mock):
        serializer = AccountRegisterSerializer(
            data={
                'email': self.account.email,
                'password': self.account.password,
                'profile': {
                    'first_name': self.account_profile.first_name,
                    'last_name': self.account_profile.last_name,
                    'phone_number': str(self.account_profile.phone_number),
                    'avatar': self.account_profile.avatar,
                    'id_card': self.account_profile.id_card,
                },
            },
        )
        assert serializer.is_valid()
        serializer.save()

        register_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=str(self.account_profile.phone_number),
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

    @mock.patch.object(RegisterAccountBL, 'process')
    def test_create_without_optional_fields(self, register_account_mock):
        serializer = AccountRegisterSerializer(
            data={
                'email': self.account.email,
                'password': self.account.password,
                'profile': {
                    'first_name': self.account_profile.first_name,
                    'last_name': self.account_profile.last_name,
                },
            },
        )

        assert serializer.is_valid()
        serializer.save()

        register_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )
