from typing import Optional

from django.conf import settings
from django.contrib.auth.models import Group

from server.apps.account.exceptions.group import GroupNotExistsError
from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.account import AccountEmailVerificationMail
from server.datastore.commands.account import AccountCommand
from server.datastore.queries.account import GroupQuery


class AccountCreateBL(AbstractBL):
    default_group_names = [settings.CLIENT]

    _token_generator = AccountEmailVerificationTokenGenerator

    @classmethod
    def process(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        phone_number: Optional[str] = None,
        avatar: Optional[str] = None,
        id_card: Optional[str] = None,
        groups: Optional[list[Group]] = None,
    ) -> Account:
        if groups is None:
            groups = cls._get_default_groups()

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
            groups=groups,
        )

        email_verification_token = cls._token_generator().make_token(user=account)
        AccountEmailVerificationMail.send(account=account, token=email_verification_token)

        return account

    @classmethod
    def _get_default_groups(cls) -> list[Group]:
        groups = []
        for name in cls.default_group_names:
            try:
                group = GroupQuery.get_by_name(name=name)
            except Group.DoesNotExist:
                raise GroupNotExistsError(name=name)
            else:
                groups.append(group)

        return groups
