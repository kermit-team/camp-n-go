from django.conf import settings
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.datastore.commands.account import AccountProfileCommand


class AccountProfileCommandTestCase(TestCase):
    def setUp(self):
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    def test_anonymize(self):
        account_profile = AccountProfileCommand.anonymize(self.account_profile)

        assert account_profile.first_name == settings.ANONYMIZED_FIRST_NAME
        assert account_profile.last_name == settings.ANONYMIZED_LAST_NAME
        assert account_profile.phone_number is None
        assert account_profile.avatar.name is None
        assert account_profile.id_card is None
