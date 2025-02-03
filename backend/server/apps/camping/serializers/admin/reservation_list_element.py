from rest_framework import serializers

from server.apps.account.serializers.admin import AdminAccountMinimizedListElementSerializer
from server.apps.camping.models import Reservation
from server.apps.camping.serializers import PaymentDetailsSerializer
from server.apps.car.serializers import CarDetailsSerializer


class AdminReservationListElementSerializer(serializers.ModelSerializer):
    user = AdminAccountMinimizedListElementSerializer(read_only=True)
    car = CarDetailsSerializer(read_only=True)
    payment = PaymentDetailsSerializer(read_only=True)

    class Meta:
        model = Reservation
        fields = [
            'id',
            'date_from',
            'date_to',
            'user',
            'car',
            'payment',
        ]
