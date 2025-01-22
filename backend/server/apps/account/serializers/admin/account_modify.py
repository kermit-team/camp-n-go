from typing import Any

from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.account_profile import AccountProfileSerializer
from server.datastore.commands.account import AccountCommand


class AdminAccountModifySerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer()

    class Meta:
        model = Account
        fields = [
            'groups',
            'is_active',
            'profile',
        ]

    def update(self, instance: Account, validated_data: Any) -> Account:
        account_data = validated_data.copy()
        profile_data = account_data.pop('profile', {})

        return AccountCommand.modify(
            account=instance,
            **account_data,
            **profile_data,
        )
