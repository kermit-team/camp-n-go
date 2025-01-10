from rest_framework import serializers

from server.apps.car.models import Car


class CarDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = ['registration_plate']
