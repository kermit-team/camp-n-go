from typing import Any

from django.conf import settings
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import serializers

from server.apps.account.errors.account import AccountErrorMessagesEnum
from server.apps.account.models import Account
from server.apps.account.serializers.account_profile import AccountProfileSerializer
from server.datastore.commands.account import AccountCommand


class AccountModifySerializer(serializers.ModelSerializer):
    old_password = serializers.CharField(max_length=settings.INTERMEDIATE_LENGTH, write_only=True)
    new_password = serializers.CharField(max_length=settings.INTERMEDIATE_LENGTH, write_only=True)
    profile = AccountProfileSerializer()

    class Meta:
        model = Account
        fields = [
            'old_password',
            'new_password',
            'profile',
        ]

    def validate(self, attrs: Any) -> Any:
        old_password = attrs.get('old_password')
        new_password = attrs.get('new_password')

        if old_password and not new_password:
            raise serializers.ValidationError(AccountErrorMessagesEnum.MISSING_NEW_PASSWORD.value)

        if not old_password and new_password:
            raise serializers.ValidationError(AccountErrorMessagesEnum.MISSING_OLD_PASSWORD.value)

        return super().validate(attrs)

    def validate_old_password(self, value: str) -> str:
        if not self.instance.check_password(raw_password=value):
            raise serializers.ValidationError(AccountErrorMessagesEnum.INVALID_PASSWORD.value)
        return value

    def validate_new_password(self, value: str) -> str:
        try:
            validate_password(password=value)
        except ValidationError as exc:
            raise serializers.ValidationError(str(exc))
        return value

    def update(self, instance: Account, validated_data: Any) -> Account:
        profile_data = validated_data.get('profile', {})

        return AccountCommand.modify(
            account=instance,
            password=validated_data.get('new_password'),
            **profile_data,
        )
