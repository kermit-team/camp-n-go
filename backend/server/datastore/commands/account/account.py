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
        **kwargs,
    ) -> Account:
        group_names = kwargs.pop('group_names', [])

        account = Account.objects.create_account(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            **kwargs,
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
        **kwargs,
    ) -> Account:
        return Account.objects.create_superuser_account(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            **kwargs,
        )

    @classmethod
    def modify(
        cls,
        account: Account,
        **kwargs,
    ) -> Account:
        if password := kwargs.pop('password', None):
            cls.change_password(account=account, password=password)

        account_profile = account.profile
        for field_name, value in kwargs.items():
            setattr(account_profile, field_name, value)

        account_profile.save()
        return account

    @classmethod
    def activate(cls, account: Account) -> None:
        account.is_active = True
        account.save()

    @classmethod
    def change_password(cls, account: Account, password: str) -> None:
        account.set_password(raw_password=password)
        account.save()

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
