from rest_framework import serializers

from server.apps.camping.models import Payment


class PaymentDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = [
            'id',
            'status',
            'price',
        ]
