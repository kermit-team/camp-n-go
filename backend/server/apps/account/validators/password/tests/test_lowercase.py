from django.core.exceptions import ValidationError
from django.test import TestCase

from server.apps.account.validators.password import LowercaseValidator


class LowercaseValidatorTestCase(TestCase):

    def test_validate(self):
        password = 'Q@werty123!'

        LowercaseValidator.validate(password=password)

    def test_validate_for_invalid_string(self):
        password = 'Q@WERTY123!'

        with self.assertRaises(ValidationError):
            LowercaseValidator.validate(password=password)
