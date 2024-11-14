from rest_framework import serializers

from server.apps.account.models import Account


class AccountEmailVerificationResendSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = [
            'email',
        ]

