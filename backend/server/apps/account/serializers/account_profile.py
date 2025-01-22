from rest_framework import serializers

from server.apps.account.models import AccountProfile


class AccountProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = AccountProfile
        fields = [
            'first_name',
            'last_name',
            'phone_number',
            'avatar',
            'id_card',
        ]
