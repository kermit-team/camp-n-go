from django.db import transaction

from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.account import AccountCommand, AccountProfileCommand


class AccountAnonymizeBL(AbstractBL):
    @classmethod
    @transaction.atomic
    def process(cls, account: Account) -> Account:
        AccountProfileCommand.anonymize(account_profile=account.profile)
        return AccountCommand.anonymize(account=account)
