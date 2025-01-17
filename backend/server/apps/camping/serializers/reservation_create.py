from typing import Any

import stripe
from django.conf import settings
from rest_framework import serializers

from server.apps.camping.models import Reservation
from server.apps.common.errors.common import CommonErrorMessagesEnum
from server.business_logic.camping import ReservationCreateBL


class ReservationCreateSerializer(serializers.ModelSerializer):
    stripe.api_key = settings.STRIPE_API_KEY

    id = serializers.IntegerField(read_only=True)
    checkout_url = serializers.SerializerMethodField()

    class Meta:
        model = Reservation
        fields = [
            'id',
            'date_from',
            'date_to',
            'number_of_adults',
            'number_of_children',
            'car',
            'camping_plot',
            'comments',
            'checkout_url',
        ]

    def create(self, validated_data: Any) -> Reservation:
        return ReservationCreateBL.process(
            date_from=validated_data.get('date_from'),
            date_to=validated_data.get('date_to'),
            number_of_adults=validated_data.get('number_of_adults'),
            number_of_children=validated_data.get('number_of_children'),
            user=self.context['request'].user,
            car=validated_data.get('car'),
            camping_plot=validated_data.get('camping_plot'),
            comments=validated_data.get('comments'),
        )

    def validate(self, attrs: Any) -> Any:
        date_from = attrs.get('date_from')
        date_to = attrs.get('date_to')

        if date_from >= date_to:
            raise serializers.ValidationError(
                CommonErrorMessagesEnum.INVALID_DATE_VALUES.value.format(date_from=date_from, date_to=date_to),
            )

        return super().validate(attrs)

    def get_checkout_url(self, obj: Reservation) -> str:
        stripe_checkout_id = obj.payment.stripe_checkout_id

        checkout_session = stripe.checkout.Session.retrieve(id=stripe_checkout_id)
        return checkout_session.url
