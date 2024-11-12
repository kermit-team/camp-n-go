from typing import Any

from rest_framework import serializers

from server.apps.account.models import Account, AccountProfile
from server.business_logic.account.register import AccountRegisterBL


class AccountProfileRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = AccountProfile
        fields = [
            'first_name',
            'last_name',
            'phone_number',
            'avatar',
            'id_card',
        ]


class AccountRegisterSerializer(serializers.ModelSerializer):
    profile = AccountProfileRegisterSerializer()

    class Meta:
        model = Account
        fields = [
            'email',
            'password',
            'profile',
        ]
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data: Any) -> Account:
        profile_data = validated_data.get('profile')

        return AccountRegisterBL.process(
            email=validated_data.get('email'),
            password=validated_data.get('password'),
            first_name=profile_data.get('first_name'),
            last_name=profile_data.get('last_name'),
            phone_number=profile_data.get('phone_number'),
            avatar=profile_data.get('avatar'),
            id_card=profile_data.get('id_card'),
        )
