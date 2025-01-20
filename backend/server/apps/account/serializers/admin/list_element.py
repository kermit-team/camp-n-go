from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.account_profile import AccountProfileSerializer
from server.apps.account.serializers.group_details import GroupDetailsSerializer


class AdminAccountListElementSerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer()
    groups = GroupDetailsSerializer(many=True)

    class Meta:
        model = Account
        fields = [
            'identifier',
            'email',
            'profile',
            'groups',
            'is_superuser',
            'is_active',
        ]
