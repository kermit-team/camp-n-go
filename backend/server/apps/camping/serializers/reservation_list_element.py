from rest_framework import serializers

from server.apps.camping.models import Reservation
from server.apps.camping.serializers import CampingPlotDetailsSerializer, PaymentDetailsSerializer
from server.datastore.queries.camping import ReservationQuery


class ReservationListElementSerializer(serializers.ModelSerializer):
    camping_plot = CampingPlotDetailsSerializer(read_only=True)
    payment = PaymentDetailsSerializer(read_only=True)
    is_cancellable = serializers.SerializerMethodField()

    class Meta:
        model = Reservation
        fields = [
            'id',
            'date_from',
            'date_to',
            'camping_plot',
            'payment',
            'is_cancellable',
        ]

    def get_is_cancellable(self, obj: Reservation) -> bool:
        return ReservationQuery.is_reservation_cancellable(reservation=obj)
