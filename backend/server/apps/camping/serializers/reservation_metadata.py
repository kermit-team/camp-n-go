from rest_framework import serializers

from server.apps.camping.models import Reservation
from server.datastore.queries.camping import ReservationQuery


class ReservationMetadataSerializer(serializers.Serializer):
    is_cancellable = serializers.SerializerMethodField()
    is_car_modifiable = serializers.SerializerMethodField()

    def get_is_cancellable(self, obj: Reservation) -> bool:
        return ReservationQuery.is_reservation_cancellable(reservation=obj)

    def get_is_car_modifiable(self, obj: Reservation) -> bool:
        return ReservationQuery.is_car_modifiable(reservation=obj)
