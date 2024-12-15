from typing import Any

from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import serializers

from server.apps.account.models import Account
from server.apps.account.serializers.profile import AccountProfileSerializer
from server.business_logic.account import AccountRegisterBL


class AccountRegisterSerializer(serializers.ModelSerializer):
    profile = AccountProfileSerializer()

    class Meta:
        model = Account
        fields = [
            'email',
            'password',
            'profile',
        ]
        extra_kwargs = {
            'password': {'write_only': True},
        }

    def create(self, validated_data: Any) -> Account:
        profile_data = validated_data.get('profile', {})

        return AccountRegisterBL.process(
            email=validated_data.get('email'),
            password=validated_data.get('password'),
            first_name=profile_data.get('first_name'),
            last_name=profile_data.get('last_name'),
            phone_number=profile_data.get('phone_number'),
            avatar=profile_data.get('avatar'),
            id_card=profile_data.get('id_card'),
        )

    def validate_password(self, value: str) -> str:
        try:
            validate_password(password=value)
        except ValidationError as exc:
            raise serializers.ValidationError(str(exc))
        return value
