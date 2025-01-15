from decimal import Decimal

from rest_framework import serializers

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.section_details import CampingSectionDetailsSerializer
from server.datastore.commands.camping.reservation import ReservationCommand


class CampingPlotAvailabilityDetailsSerializer(serializers.ModelSerializer):
    camping_section = CampingSectionDetailsSerializer(read_only=True)
    price = serializers.SerializerMethodField()

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
            'price',
        ]

    def get_price(self, obj: CampingPlot) -> Decimal:
        date_from = self.context['request'].data['date_from']
        date_to = self.context['request'].data['date_to']
        number_of_adults = self.context['request'].data['number_of_adults']
        number_of_children = self.context['request'].data['number_of_children']

        return ReservationCommand.calculate_overall_price(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            camping_section=obj.camping_section,
        )
