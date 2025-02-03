from django.test import TestCase

from server.apps.account.serializers import AccountPasswordResetSerializer
from server.utils.tests.baker_generators import generate_password


class AccountPasswordResetSerializerTestCase(TestCase):

    def test_validate(self):
        password = generate_password()
        serializer = AccountPasswordResetSerializer(data={'password': password})

        assert serializer.is_valid()

    def test_validate_invalid_password(self):
        password = 'bad_password'
        serializer = AccountPasswordResetSerializer(data={'password': password})

        assert not serializer.is_valid()

        assert 'password' in serializer.errors
