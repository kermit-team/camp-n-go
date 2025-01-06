from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.group import GroupSerializer
from server.apps.account.serializers.profile import AccountProfileSerializer
from server.apps.car.serializers import CarDetailsSerializer


class AccountDetailsSerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer()
    cars = CarDetailsSerializer(many=True)
    groups = GroupSerializer(many=True)

    class Meta:
        model = Account
        fields = [
            'email',
            'profile',
            'cars',
            'groups',
            'is_superuser',
            'is_active',
        ]
