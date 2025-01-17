from rest_framework import serializers

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.plot_availability_metadata import CampingPlotAvailabilityMetadataSerializer
from server.apps.camping.serializers.section_details import CampingSectionDetailsSerializer


class CampingPlotAvailabilityListElementSerializer(serializers.ModelSerializer):
    camping_section = CampingSectionDetailsSerializer(read_only=True)
    metadata = serializers.SerializerMethodField()

    class Meta:
        model = CampingPlot
        fields = [
            'id',
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
            'metadata',
        ]

    def get_metadata(self, obj: CampingPlot) -> CampingPlotAvailabilityMetadataSerializer:
        return CampingPlotAvailabilityMetadataSerializer(obj, context=self.context).data
