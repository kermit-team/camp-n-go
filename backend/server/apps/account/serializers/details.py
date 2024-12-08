from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.profile import AccountProfileSerializer


class AccountDetailsSerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer()

    class Meta:
        model = Account
        fields = [
            'email',
            'profile',
        ]
