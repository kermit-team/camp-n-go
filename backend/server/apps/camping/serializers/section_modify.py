from typing import Any

from rest_framework import serializers

from server.apps.camping.models import CampingSection
from server.datastore.commands.camping import CampingSectionCommand


class CampingSectionModifySerializer(serializers.ModelSerializer):
    name = serializers.CharField(read_only=True)

    class Meta:
        model = CampingSection
        fields = [
            'name',
            'base_price',
            'price_per_adult',
            'price_per_child',
        ]

    def update(self, instance: CampingSection, validated_data: Any) -> CampingSection:
        return CampingSectionCommand.modify(
            camping_section=instance,
            base_price=validated_data.get('base_price'),
            price_per_adult=validated_data.get('price_per_adult'),
            price_per_child=validated_data.get('price_per_child'),
        )
