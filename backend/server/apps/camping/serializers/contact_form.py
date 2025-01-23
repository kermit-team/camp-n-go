from django.conf import settings
from rest_framework import serializers


class ContactFormSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)
    content = serializers.CharField(max_length=settings.XL_LENGTH, required=True)
