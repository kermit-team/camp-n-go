from unittest import mock

from django.contrib.auth.hashers import make_password
from django.test import TestCase
from model_bakery import baker

from server.apps.account.errors.account import AccountErrorMessagesEnum
from server.apps.account.models import Account, AccountProfile
from server.apps.account.serializers import AccountModifySerializer
from server.datastore.commands.account import AccountCommand
from server.utils.tests.baker_generators import generate_password


class AccountModifySerializerTestCase(TestCase):

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(
            _model=Account,
            password=make_password(self.password),
            _fill_optional=True,
        )
        baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'modify')
    def test_update(self, modify_account_mock):
        new_password = generate_password()

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': self.password,
                'new_password': new_password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
        )

        assert serializer.is_valid()
        serializer.save()

        modify_account_mock.assert_called_once_with(
            account=self.account,
            password=new_password,
            first_name=self.new_profile_data.first_name,
            last_name=self.new_profile_data.last_name,
            phone_number=str(self.new_profile_data.phone_number),
            avatar=self.new_profile_data.avatar,
            id_card=self.new_profile_data.id_card,
        )

    @mock.patch.object(AccountCommand, 'modify')
    def test_update_without_required_fields(self, modify_account_mock):
        new_password = generate_password()

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': self.password,
                'new_password': new_password,
            },
        )

        assert not serializer.is_valid()
        modify_account_mock.assert_not_called()

    @mock.patch.object(AccountCommand, 'modify')
    def test_partial_update(self, modify_account_mock):
        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                },
            },
            partial=True,
        )

        assert serializer.is_valid()
        serializer.save()

        modify_account_mock.assert_called_once_with(
            account=self.account,
            password=None,
            first_name=self.new_profile_data.first_name,
            last_name=self.new_profile_data.last_name,
            phone_number=None,
            avatar=None,
            id_card=None,
        )

    def test_validate(self):
        new_password = generate_password()

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': self.password,
                'new_password': new_password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
            partial=True,
        )

        assert serializer.is_valid()

    def test_validate_missing_old_password(self):
        new_password = generate_password()

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'new_password': new_password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
            partial=True,
        )

        assert not serializer.is_valid()
        assert serializer.errors.get('non_field_errors', None)
        assert AccountErrorMessagesEnum.MISSING_OLD_PASSWORD.value in serializer.errors['non_field_errors']

    def test_validate_missing_new_password(self):
        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': self.password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
            partial=True,
        )

        assert not serializer.is_valid()
        assert serializer.errors.get('non_field_errors', None)
        assert AccountErrorMessagesEnum.MISSING_NEW_PASSWORD.value in serializer.errors['non_field_errors']

    def test_validate_invalid_password(self):
        password = 'not_matching_password'
        new_password = generate_password()

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': password,
                'new_password': new_password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
            partial=True,
        )

        assert not serializer.is_valid()
        assert 'old_password' in serializer.errors

    def test_validate_invalid_new_password(self):
        new_password = 'bad_password'

        serializer = AccountModifySerializer(
            instance=self.account,
            data={
                'old_password': self.password,
                'new_password': new_password,
                'profile': {
                    'first_name': self.new_profile_data.first_name,
                    'last_name': self.new_profile_data.last_name,
                    'phone_number': str(self.new_profile_data.phone_number),
                    'avatar': self.new_profile_data.avatar,
                    'id_card': self.new_profile_data.id_card,
                },
            },
            partial=True,
        )

        assert not serializer.is_valid()
        assert 'new_password' in serializer.errors
