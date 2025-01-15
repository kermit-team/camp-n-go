from rest_framework import serializers

from server.apps.account.serializers import AccountDetailsSerializer
from server.apps.camping.models import Reservation
from server.apps.camping.serializers import CampingPlotDetailsSerializer
from server.apps.car.serializers import CarDetailsSerializer
from server.datastore.commands.camping.reservation import ReservationCommand


class ReservationDetailsSerializer(serializers.ModelSerializer):
    user = AccountDetailsSerializer(read_only=True)
    car = CarDetailsSerializer(read_only=True)
    camping_plot = CampingPlotDetailsSerializer(read_only=True)
    is_cancellable = serializers.SerializerMethodField()

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
            'is_cancellable',
        ]

    def get_is_cancellable(self, obj: Reservation) -> bool:
        return ReservationCommand.is_reservation_cancellable(reservation=obj)
