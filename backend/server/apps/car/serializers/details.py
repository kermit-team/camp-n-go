from rest_framework import serializers

from server.apps.car.models import Car


class CarDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = ['registration_plate']
