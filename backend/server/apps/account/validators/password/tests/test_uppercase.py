from django.core.exceptions import ValidationError
from django.test import TestCase

from server.apps.account.validators.password import UppercaseValidator


class UppercaseValidatorTestCase(TestCase):

    def test_validate(self):
        password = 'Q@werty123!'

        UppercaseValidator.validate(password=password)

    def test_validate_for_invalid_string(self):
        password = 'q@werty123!'

        with self.assertRaises(ValidationError):
            UppercaseValidator.validate(password=password)
