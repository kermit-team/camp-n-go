from django.conf import settings
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.account.models import Account
from server.apps.common.models.created_updated import CreatedUpdatedMixin


class Car(CreatedUpdatedMixin):
    registration_plate = models.CharField(
        verbose_name=_('RegistrationPlate'),
        blank=False,
        null=False,
        editable=False,
        unique=True,
        max_length=settings.TINY_LENGTH,
    )

    drivers = models.ManyToManyField(
        verbose_name=_('Drivers'),
        to=Account,
        related_name='cars',
    )

    def __str__(self) -> str:  # pragma: no cover
        return self.registration_plate
