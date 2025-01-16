from typing import Any

from rest_framework import serializers

from server.apps.camping.models import CampingSection
from server.datastore.commands.camping import CampingSectionCommand


class CampingSectionModifySerializer(serializers.ModelSerializer):
    class Meta:
        model = CampingSection
        fields = [
            'base_price',
            'price_per_adult',
            'price_per_child',
        ]

    def update(self, instance: CampingSection, validated_data: Any) -> CampingSection:
        return CampingSectionCommand.modify(
            camping_section=instance,
            **validated_data,
        )
