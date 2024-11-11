from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.business_logic.account.register import RegisterAccountBL
from server.datastore.commands.account import AccountCommand


class RegisterAccountBLTestCase(TestCase):

    def setUp(self):
        self.account = baker.prepare(_model=Account, _fill_optional=True)
        self.account_profile = baker.prepare(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(AccountCommand, 'create')
    def test_process(self, create_account_mock):
        RegisterAccountBL.process(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
        )

        create_account_mock.assert_called_once_with(
            email=self.account.email,
            password=self.account.password,
            first_name=self.account_profile.first_name,
            last_name=self.account_profile.last_name,
            is_superuser=False,
            is_active=False,
            phone_number=self.account_profile.phone_number,
            avatar=self.account_profile.avatar,
            id_card=self.account_profile.id_card,
            group_names=RegisterAccountBL.group_names,
        )
