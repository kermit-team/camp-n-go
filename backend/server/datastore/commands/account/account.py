from django.db import transaction

from server.apps.account.models import Account


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
        groups = kwargs.pop('groups', [])

        account = Account.objects.create_account(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            **kwargs,
        )

        if groups:
            account.groups.set(groups, clear=True)

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

        groups = kwargs.pop('groups', None)
        if groups is not None:
            account.groups.set(groups, clear=True)

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
