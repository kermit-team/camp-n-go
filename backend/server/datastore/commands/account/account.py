from typing import Optional

from django.contrib.auth.models import Group
from django.db import transaction

from server.apps.account.exceptions.group import GroupNotExistsError
from server.apps.account.models import Account
from server.datastore.queries.account import GroupQuery


class AccountCommand:

    @classmethod
    @transaction.atomic
    def create(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        is_superuser: Optional[bool] = False,
        is_active: Optional[bool] = True,
        phone_number: Optional[str] = None,
        avatar: Optional[str] = None,
        id_card: Optional[str] = None,
        group_names: Optional[list[str]] = None,
    ) -> Account:
        account = Account.objects.create_account(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            is_superuser=is_superuser,
            is_active=is_active,
            phone_number=phone_number,
            avatar=avatar,
            id_card=id_card,
        )

        if group_names:
            cls._add_groups_to_account(account=account, names=group_names)

        return account

    @classmethod
    def create_superuser(
        cls,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        is_active: Optional[bool] = True,
        phone_number: Optional[str] = None,
        avatar: Optional[str] = None,
        id_card: Optional[str] = None,
    ) -> Account:
        return Account.objects.create_superuser_account(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            is_active=is_active,
            phone_number=phone_number,
            avatar=avatar,
            id_card=id_card,
        )

    @classmethod
    def _add_groups_to_account(cls, account: Account, names: list[str]) -> None:
        groups = []
        for name in names:
            try:
                group = GroupQuery.get_by_name(name=name)
            except Group.DoesNotExist:
                raise GroupNotExistsError(name=name)
            else:
                groups.append(group)
        account.groups.set(groups, clear=True)
