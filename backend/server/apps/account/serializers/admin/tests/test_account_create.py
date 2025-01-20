from unittest import mock

from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.account.serializers.admin import AdminAccountCreateSerializer
from server.business_logic.account import AccountCreateBL
from server.utils.tests.baker_generators import generate_password


class AdminAccountCreateSerializerTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.groups = baker.make(_model=Group, _quantity=2)

    @mock.patch.object(AccountCreateBL, 'process')
    def test_create(self, create_account_mock):
        serializer = AdminAccountCreateSerializer(
            data={
                'email': self.account.email,
                'password': self.account.password,
                'groups': [group.id for group in self.groups],
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

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=str(self.account_profile.phone_number),
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            groups=self.groups,
        )

    @mock.patch.object(AccountCreateBL, 'process')
    def test_create_without_optional_fields(self, create_account_mock):
        serializer = AdminAccountCreateSerializer(
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

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
            groups=[],
        )

    def test_validate(self):
        serializer = AdminAccountCreateSerializer(
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

    def test_validate_invalid_password(self):
        password = 'bad_password'
        serializer = AdminAccountCreateSerializer(
            data={
                'email': self.account.email,
                'password': password,
                'profile': {
                    'first_name': self.account_profile.first_name,
                    'last_name': self.account_profile.last_name,
                },
            },
        )

        assert not serializer.is_valid()

        assert 'password' in serializer.errors
