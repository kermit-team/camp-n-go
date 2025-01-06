from django.conf import settings
from django.core.validators import MinValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.common.models.created_updated import CreatedUpdatedMixin


class CampingSection(CreatedUpdatedMixin):
    name = models.CharField(
        verbose_name=_('Name'),
        max_length=settings.MICRO_LENGTH,
        unique=True,
        blank=False,
        null=False,
    )
    base_price = models.DecimalField(
        verbose_name=_('BasePrice'),
        max_digits=settings.PLOT_PRICE_DIGITS,
        decimal_places=settings.PRICE_DECIMAL_PLACES,
        validators=[MinValueValidator(settings.PRICE_MIN_VALUE)],
    )
    price_per_adult = models.DecimalField(
        verbose_name=_('PricePerAdult'),
        max_digits=settings.PLOT_PRICE_DIGITS,
        decimal_places=settings.PRICE_DECIMAL_PLACES,
        validators=[MinValueValidator(settings.PRICE_MIN_VALUE)],
    )
    price_per_child = models.DecimalField(
        verbose_name=_('PricePerChild'),
        max_digits=settings.PLOT_PRICE_DIGITS,
        decimal_places=settings.PRICE_DECIMAL_PLACES,
        validators=[MinValueValidator(settings.PRICE_MIN_VALUE)],
    )

    def __str__(self) -> str:  # pragma: no cover
        return self.name
