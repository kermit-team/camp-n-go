from django.conf import settings
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.account.models import Account
from server.apps.camping.models import CampingPlot, Payment
from server.apps.car.models import Car
from server.apps.common.models.created_updated import CreatedUpdatedMixin


class Reservation(CreatedUpdatedMixin):
    _name_schema = '{user} - {camping_plot} [{date_from} - {date_to}]'

    date_from = models.DateField(verbose_name=_('DateFrom'))
    date_to = models.DateField(verbose_name=_('DateTo'))
    number_of_adults = models.PositiveSmallIntegerField(verbose_name=_('NumberOfAdults'))
    number_of_children = models.PositiveSmallIntegerField(verbose_name=_('NumberOfChildren'))
    comments = models.TextField(
        verbose_name=_('Comments'),
        max_length=settings.XXL_LENGTH,
        blank=True,
        null=True,
    )

    user = models.ForeignKey(
        verbose_name=_('User'),
        to=Account,
        on_delete=models.RESTRICT,
        related_name='reservations',
    )
    car = models.ForeignKey(
        verbose_name=_('Car'),
        to=Car,
        on_delete=models.RESTRICT,
        related_name='reservations',
    )
    camping_plot = models.ForeignKey(
        verbose_name=_('CampingPlot'),
        to=CampingPlot,
        on_delete=models.RESTRICT,
        related_name='reservations',
    )
    payment = models.OneToOneField(
        verbose_name=_('Payment'),
        to=Payment,
        on_delete=models.RESTRICT,
        related_name='reservations',
    )

    def __str__(self) -> str:  # pragma: no cover
        name = self._name_schema.format(
            user=str(self.user),
            camping_plot=str(self.camping_plot),
            date_from=str(self.date_from),
            date_to=str(self.date_to),
        )
        return name.strip()
