from rest_framework import serializers

from server.apps.car.models import Car


class CarRemoveDriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = ['registration_plate']
        extra_kwargs = {
            'registration_plate': {'read_only': False},
        }
