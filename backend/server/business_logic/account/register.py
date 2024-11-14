from typing import Optional

from django.conf import settings
from django.db import transaction

from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.commands.account import AccountCommand


class AccountRegisterBL(AbstractBL):
    default_group_names = [settings.CLIENT]

    _token_generator = AccountEmailVerificationTokenGenerator

    @classmethod
    @transaction.atomic
    def process(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        phone_number: Optional[str] = None,
        avatar: Optional[str] = None,
        id_card: Optional[str] = None,
    ) -> Account:
        account = AccountCommand.create(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            is_superuser=False,
            is_active=False,
            phone_number=phone_number,
            avatar=avatar,
            id_card=id_card,
            group_names=cls.default_group_names,
        )

        email_verification_token = cls._token_generator().make_token(user=account)
        AccountEmailVerificationMail.send(account=account, token=email_verification_token)

        return account
