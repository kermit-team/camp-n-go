from django.core.exceptions import ValidationError
from django.test import TestCase

from server.apps.account.validators.password import SpecialCharacterValidator


class SpecialCharacterValidatorTestCase(TestCase):

    def test_validate(self):
        password = 'Q@werty123!'

        SpecialCharacterValidator.validate(password=password)

    def test_validate_for_invalid_string(self):
        password = 'Qawerty1231'

        with self.assertRaises(ValidationError):
            SpecialCharacterValidator.validate(password=password)
