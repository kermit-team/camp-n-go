from django.conf import settings
from django.core.validators import MinValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.camping.models.section import CampingSection
from server.apps.common.models.created_updated import CreatedUpdatedMixin


class CampingPlot(CreatedUpdatedMixin):
    _name_schema = '{section_name}_{position}'

    position = models.CharField(
        verbose_name=_('Position'),
        max_length=settings.MICRO_LENGTH,
    )
    max_number_of_people = models.PositiveSmallIntegerField(verbose_name=_('MaximumNumberOfPeople'))
    width = models.DecimalField(
        verbose_name=_('Width'),
        help_text=_('PlotWidthHelpText'),
        validators=[MinValueValidator(settings.PLOT_SIZE_MIN_VALUE)],
        max_digits=settings.PLOT_SIZE_DIGITS,
        decimal_places=settings.PLOT_SIZE_DECIMAL_PLACES,
    )
    length = models.DecimalField(
        verbose_name=_('Length'),
        help_text=_('PlotLengthHelpText'),
        validators=[MinValueValidator(settings.PLOT_SIZE_MIN_VALUE)],
        max_digits=settings.PLOT_SIZE_DIGITS,
        decimal_places=settings.PLOT_SIZE_DECIMAL_PLACES,
    )
    water_connection = models.BooleanField(
        verbose_name=_('WaterConnection'),
        default=False,
    )
    electricity_connection = models.BooleanField(
        verbose_name=_('ElectricityConnection'),
        default=False,
    )
    is_shaded = models.BooleanField(
        verbose_name=_('IsShaded'),
        default=False,
    )
    grey_water_discharge = models.BooleanField(
        verbose_name=_('GreyWaterDischarge'),
        default=False,
    )
    description = models.TextField(
        verbose_name=_('Description'),
        max_length=settings.XL_LENGTH,
        blank=True,
        null=True,
    )

    camping_section = models.ForeignKey(
        verbose_name=_('CampingSection'),
        to=CampingSection,
        on_delete=models.CASCADE,
        related_name='camping_plots',
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['position', 'camping_section'], name='unique_camping_plot'),
        ]

    def __str__(self) -> str:  # pragma: no cover
        name = self._name_schema.format(section_name=self.camping_section.name, position=self.position)
        return name.strip()
