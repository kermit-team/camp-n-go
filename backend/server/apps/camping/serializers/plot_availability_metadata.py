from decimal import Decimal

from django.utils.dateparse import parse_date
from rest_framework import serializers
from server.apps.camping.models import CampingPlot
from server.datastore.queries.camping import ReservationQuery


class CampingPlotAvailabilityMetadataSerializer(serializers.Serializer):
    overall_price = serializers.SerializerMethodField()
    base_price = serializers.SerializerMethodField()
    adults_price = serializers.SerializerMethodField()
    children_price = serializers.SerializerMethodField()

    def get_overall_price(self, obj: CampingPlot) -> Decimal:
        date_from = parse_date(self.context['request'].query_params['date_from'])
        date_to = parse_date(self.context['request'].query_params['date_to'])
        number_of_adults = int(self.context['request'].query_params['number_of_adults'])
        number_of_children = int(self.context['request'].query_params['number_of_children'])

        return ReservationQuery.calculate_overall_price(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            camping_section=obj.camping_section,
        )

    def get_base_price(self, obj: CampingPlot) -> Decimal:
        date_from = parse_date(self.context['request'].query_params['date_from'])
        date_to = parse_date(self.context['request'].query_params['date_to'])

        return ReservationQuery.calculate_base_price(
            date_from=date_from,
            date_to=date_to,
            camping_section=obj.camping_section,
        )

    def get_adults_price(self, obj: CampingPlot) -> Decimal:
        date_from = parse_date(self.context['request'].query_params['date_from'])
        date_to = parse_date(self.context['request'].query_params['date_to'])
        number_of_adults = int(self.context['request'].query_params['number_of_adults'])

        return ReservationQuery.calculate_adults_price(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            camping_section=obj.camping_section,
        )

    def get_children_price(self, obj: CampingPlot) -> Decimal:
        date_from = parse_date(self.context['request'].query_params['date_from'])
        date_to = parse_date(self.context['request'].query_params['date_to'])
        number_of_children = int(self.context['request'].query_params['number_of_children'])

        return ReservationQuery.calculate_children_price(
            date_from=date_from,
            date_to=date_to,
            number_of_children=number_of_children,
            camping_section=obj.camping_section,
        )
