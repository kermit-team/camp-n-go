from typing import Any

from rest_framework import serializers

from server.apps.camping.models import Reservation
from server.business_logic.camping import ReservationModifyCarBL


class ReservationModifyCarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reservation
        fields = ['car']

    def update(self, instance: Reservation, validated_data: Any) -> Reservation:
        return ReservationModifyCarBL.process(
            reservation=instance,
            car=validated_data.get('car'),
        )
