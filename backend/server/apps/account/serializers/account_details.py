from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.account_profile import AccountProfileSerializer
from server.apps.account.serializers.group_details import GroupDetailsSerializer
from server.apps.car.serializers import CarDetailsSerializer


class AccountDetailsSerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer(read_only=True)
    cars = CarDetailsSerializer(read_only=True, many=True)
    groups = GroupDetailsSerializer(read_only=True, many=True)

    class Meta:
        model = Account
        fields = [
            'identifier',
            'email',
            'profile',
            'cars',
            'groups',
            'is_superuser',
            'is_active',
        ]
