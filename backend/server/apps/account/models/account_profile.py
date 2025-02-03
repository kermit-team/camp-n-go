import os

from django.conf import settings
from django.db import models
from django.utils.translation import gettext_lazy as _
from phonenumber_field import modelfields

from server.apps.common.models.created_updated import CreatedUpdatedMixin


class AccountProfile(CreatedUpdatedMixin):
    _full_name_schema = '{first_name} {last_name}'

    first_name = models.CharField(
        verbose_name=_('FirstName'),
        max_length=settings.INTERMEDIATE_LENGTH,
        blank=False,
        null=False,
    )
    last_name = models.CharField(
        verbose_name=_('LastName'),
        max_length=settings.INTERMEDIATE_LENGTH,
        blank=False,
        null=False,
    )
    phone_number = modelfields.PhoneNumberField(
        verbose_name=_('PhoneNumber'),
        null=True,
        blank=True,
    )
    avatar = models.ImageField(
        verbose_name=_('Avatar'),
        default=os.path.join(
            settings.AVATARS_SUBDIRECTORY,
            settings.AVATAR_DEFAULT_IMAGE,
        ),
        upload_to=settings.AVATARS_SUBDIRECTORY,
    )
    id_card = models.CharField(
        verbose_name=_('IdCard'),
        null=True,
        unique=True,
        max_length=settings.SMALL_LENGTH,
    )

    account = models.OneToOneField(
        to=settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        verbose_name=_('Account'),
        related_name='profile',
    )

    def __str__(self) -> str:  # pragma: no cover
        return str(self.account)

    @property
    def full_name(self) -> str:  # pragma: no cover
        full_name = self._full_name_schema.format(first_name=self.first_name, last_name=self.last_name)
        return full_name.strip()

    @property
    def short_name(self) -> str:  # pragma: no cover
        return self.first_name
