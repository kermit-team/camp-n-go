from rest_framework import serializers

from server.apps.account.models import Account


class AccountEmailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['email']
