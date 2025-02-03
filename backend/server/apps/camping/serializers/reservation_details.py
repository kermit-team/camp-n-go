from rest_framework import serializers

from server.apps.account.serializers import AccountDetailsSerializer
from server.apps.camping.models import Reservation
from server.apps.camping.serializers import CampingPlotDetailsSerializer, PaymentDetailsSerializer
from server.apps.camping.serializers.reservation_metadata import ReservationMetadataSerializer
from server.apps.car.serializers import CarDetailsSerializer


class ReservationDetailsSerializer(serializers.ModelSerializer):
    user = AccountDetailsSerializer(read_only=True)
    car = CarDetailsSerializer(read_only=True)
    camping_plot = CampingPlotDetailsSerializer(read_only=True)
    payment = PaymentDetailsSerializer(read_only=True)
    metadata = ReservationMetadataSerializer(source='*', read_only=True)

    class Meta:
        model = Reservation
        fields = [
            'id',
            'date_from',
            'date_to',
            'number_of_adults',
            'number_of_children',
            'comments',
            'user',
            'car',
            'camping_plot',
            'payment',
            'metadata',
        ]
