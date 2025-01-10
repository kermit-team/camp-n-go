from decimal import Decimal
from typing import Any

from server.apps.camping.exceptions.section import CampingSectionNotExistsError
from server.apps.camping.models import CampingPlot, CampingSection
from server.datastore.queries.camping import CampingSectionQuery


class CampingPlotCommand:

    @classmethod
    def create(
        cls,
        position: str,
        max_number_of_people: int,
        width: Decimal,
        length: Decimal,
        camping_section_name: str,
        **kwargs: Any,
    ) -> CampingPlot:
        try:
            camping_section = CampingSectionQuery.get_by_name(name=camping_section_name)
        except CampingSection.DoesNotExist:
            raise CampingSectionNotExistsError(name=camping_section_name)

        camping_plot = CampingPlot(
            position=position,
            max_number_of_people=max_number_of_people,
            width=width,
            length=length,
            camping_section=camping_section,
        )

        for field, value in kwargs.items():
            setattr(camping_plot, field, value)

        camping_plot.save()
        return camping_plot
