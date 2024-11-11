from uuid import uuid4

from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.account.managers import AccountManager
from server.apps.common.models.created_updated import CreatedUpdatedMixin


class Account(CreatedUpdatedMixin, PermissionsMixin, AbstractBaseUser):
    identifier = models.UUIDField(
        verbose_name=_('Identifier'),
        default=uuid4,
        editable=False,
        unique=True,
    )
    email = models.EmailField(
        verbose_name=_('EmailAddress'),
        blank=False,
        null=False,
        unique=True,
    )
    is_active = models.BooleanField(
        verbose_name=_('IsActive'),
        default=True,
        help_text=_(
            'Designates whether this account should be treated as active. '
            'Unselect this instead of deleting accounts.',
        ),
    )

    objects = AccountManager()

    USERNAME_FIELD = 'email'

    def __str__(self) -> str:
        return str(self.identifier)  # pragma: no cover

    def clean(self) -> None:  # pragma: no cover
        super().clean()
        self.email = self.__class__.objects.normalize_email(self.email)  # noqa: WPS601
