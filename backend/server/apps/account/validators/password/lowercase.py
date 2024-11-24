import re
from typing import Optional

from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

from server.apps.account.models import Account


class LowercaseValidator:
    @staticmethod
    def validate(password: str, user: Optional[Account] = None):
        if not re.findall(pattern=r'[a-z]', string=password):
            raise ValidationError(
                _('The password must contain at least 1 lowercase letter, a-z.'),
                code='password_no_lower',
            )

    @staticmethod
    def get_help_text():
        return _('Your password must contain at least 1 lowercase letter, a-z.')  # pragma: no cover
