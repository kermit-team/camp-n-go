from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import serializers

from server.apps.account.models import Account


class AccountPasswordResetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['password']
        extra_kwargs = {'password': {'write_only': True}}

    def validate_password(self, value: str) -> str:
        try:
            validate_password(password=value)
        except ValidationError as exc:
            raise serializers.ValidationError(str(exc))
        return value
