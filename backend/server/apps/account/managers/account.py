from typing import Any

from django.conf import settings
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.hashers import make_password
from django.db import transaction


class AccountManager(BaseUserManager):
    use_in_migrations = True

    @transaction.atomic
    def create_account(
        self,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        **kwargs,
    ) -> settings.AUTH_USER_MODEL:
        account = self._create_account(
            email=email,
            password=password,
            is_superuser=kwargs.pop('is_superuser', False),
            is_active=kwargs.pop('is_active', True),
        )
        self._create_account_profile(
            account=account,
            first_name=first_name,
            last_name=last_name,
            **kwargs,
        )

        return account

    @transaction.atomic
    def create_superuser_account(
        self,
        email: str,
        password: str,
        first_name: str,
        last_name: str,
        **kwargs,
    ) -> settings.AUTH_USER_MODEL:
        is_superuser = True

        account = self._create_account(
            email=email,
            password=password,
            is_superuser=is_superuser,
            is_active=kwargs.pop('is_active', True),
        )
        self._create_account_profile(
            account=account,
            first_name=first_name,
            last_name=last_name,
            **kwargs,
        )

        return account

    def _create_account(
        self,
        email: str,
        password: str,
        **extra_fields: Any,
    ) -> settings.AUTH_USER_MODEL:
        email = self.normalize_email(email=email)

        account = self.model(
            email=email,
            **extra_fields,
        )
        account.password = make_password(password=password)
        account.save(using=self._db)

        return account

    def _create_account_profile(
        self,
        account: settings.AUTH_USER_MODEL,
        first_name: str,
        last_name: str,
        **extra_fields: Any,
    ) -> None:
        # This import is added here to avoid circular imports.
        from server.apps.account.models import AccountProfile  # noqa: WPS433

        AccountProfile.objects.create(account=account, first_name=first_name, last_name=last_name, **extra_fields)
