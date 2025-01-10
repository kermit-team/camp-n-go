from rest_framework import serializers

from server.apps.camping.models import CampingSection


class CampingSectionDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CampingSection
        fields = [
            'name',
            'base_price',
            'price_per_adult',
            'price_per_child',
        ]
