from typing import Any

from rest_framework import serializers

from server.apps.car.models import Car
from server.datastore.commands.car import CarCommand


class CarAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = ['registration_plate']
        extra_kwargs = {
            'registration_plate': {'read_only': False},
        }

    def create(self, validated_data: Any) -> Car:
        return CarCommand.add(
            registration_plate=validated_data.get('registration_plate'),
            driver=self.context['request'].user,
        )
