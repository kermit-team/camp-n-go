from unittest import mock

from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.account.serializers.admin import AdminAccountModifySerializer
from server.datastore.commands.account import AccountCommand
from server.utils.tests.baker_generators import generate_password


class AdminAccountModifySerializerTestCase(TestCase):

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(
            _model=Account,
            password=make_password(self.password),
            is_active=True,
            _fill_optional=True,
        )
        self.groups = baker.make(_model=Group, _quantity=2)
        baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.new_profile_data = baker.prepare(_model=AccountProfile, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'modify')
    def test_update(self, modify_account_mock):
        is_active = False
        serializer = AdminAccountModifySerializer(
            instance=self.account,
            data={
                'groups': [group.id for group in self.groups],
                'is_active': is_active,
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
            groups=self.groups,
            is_active=is_active,
            first_name=self.new_profile_data.first_name,
            last_name=self.new_profile_data.last_name,
            phone_number=str(self.new_profile_data.phone_number),
            avatar=self.new_profile_data.avatar,
            id_card=self.new_profile_data.id_card,
        )

    @mock.patch.object(AccountCommand, 'modify')
    def test_partial_update(self, modify_account_mock):
        serializer = AdminAccountModifySerializer(
            instance=self.account,
            data={
                'groups': [group.id for group in self.groups],
                'is_active': False,
            },
            partial=True,
        )

        assert serializer.is_valid()
        serializer.save()

        modify_account_mock.assert_called_once_with(
            account=self.account,
            groups=self.groups,
            is_active=False,
        )
