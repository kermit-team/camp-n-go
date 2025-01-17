from decimal import Decimal
from typing import Any

from server.apps.camping.models import CampingSection


class CampingSectionCommand:

    @classmethod
    def create(
        cls,
        name: str,
        base_price: Decimal,
        price_per_adult: Decimal,
        price_per_child: Decimal,
    ) -> CampingSection:
        return CampingSection.objects.create(
            name=name,
            base_price=base_price,
            price_per_adult=price_per_adult,
            price_per_child=price_per_child,
        )

    @classmethod
    def modify(cls, camping_section: CampingSection, **kwargs: Any) -> CampingSection:
        for field, value in kwargs.items():
            setattr(camping_section, field, value)

        camping_section.save()
        return camping_section
