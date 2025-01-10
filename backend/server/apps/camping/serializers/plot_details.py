from rest_framework import serializers

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.section_details import CampingSectionDetailsSerializer


class CampingPlotDetailsSerializer(serializers.ModelSerializer):
    camping_section = CampingSectionDetailsSerializer(read_only=True)

    class Meta:
        model = CampingPlot
        fields = [
            'position',
            'max_number_of_people',
            'width',
            'length',
            'water_connection',
            'electricity_connection',
            'is_shaded',
            'grey_water_discharge',
            'description',
            'camping_section',
        ]
