from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.account_profile_minimized import AccountProfileMinimizedSerializer


class AdminAccountMinimizedListElementSerializer(serializers.ModelSerializer):
    profile = AccountProfileMinimizedSerializer(read_only=True)

    class Meta:
        model = Account
        fields = [
            'identifier',
            'profile',
        ]
