from unittest import mock

from django.core.exceptions import ValidationError
from django.test import TestCase
from model_bakery import baker
from rest_framework.exceptions import ErrorDetail

from server.apps.account.models import Account, AccountProfile
from server.apps.account.serializers import AccountRegisterSerializer
from server.business_logic.account import AccountRegisterBL
from server.utils.tests.baker_generators import generate_password


class AccountRegisterSerializerTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountRegisterBL, 'process')
    @mock.patch('server.apps.account.serializers.register.validate_password')
    def test_create(self, validate_password_mock, register_account_mock):
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

        validate_password_mock.assert_called_once_with(password=self.account.password)
        register_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=str(self.account_profile.phone_number),
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

    @mock.patch.object(AccountRegisterBL, 'process')
    @mock.patch('server.apps.account.serializers.register.validate_password')
    def test_create_without_optional_fields(self, validate_password_mock, register_account_mock):
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

        validate_password_mock.assert_called_once_with(password=self.account.password)
        register_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )

    @mock.patch('server.apps.account.serializers.register.validate_password')
    def test_validate(self, validate_password_mock):
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

        validate_password_mock.assert_called_once_with(password=self.account.password)

    @mock.patch('server.apps.account.serializers.register.validate_password')
    def test_validate_invalid_password(self, validate_password_mock):
        validate_password_mock.side_effect = ValidationError('Wrong password')

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

        assert not serializer.is_valid()

        validate_password_mock.assert_called_once_with(password=self.account.password)

        assert 'password' in serializer.errors
        assert serializer.errors['password'] == [
            ErrorDetail(string="['Wrong password']", code='invalid'),
        ]
