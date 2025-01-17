from rest_framework import serializers

from server.apps.camping.models import Reservation
from server.apps.camping.serializers import CampingPlotDetailsSerializer, PaymentDetailsSerializer
from server.apps.camping.serializers.reservation_metadata import ReservationMetadataSerializer


class ReservationListElementSerializer(serializers.ModelSerializer):
    camping_plot = CampingPlotDetailsSerializer(read_only=True)
    payment = PaymentDetailsSerializer(read_only=True)
    metadata = ReservationMetadataSerializer(source='*', read_only=True)

    class Meta:
        model = Reservation
        fields = [
            'id',
            'date_from',
            'date_to',
            'camping_plot',
            'payment',
            'metadata',
        ]
