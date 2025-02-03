import re
from typing import Optional

from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

from server.apps.account.models import Account


class UppercaseValidator:
    @staticmethod
    def validate(password: str, user: Optional[Account] = None):
        if not re.findall(pattern=r'[A-Z]', string=password):
            raise ValidationError(
                _('The password must contain at least 1 uppercase letter, A-Z.'),
                code='password_no_upper',
            )

    @staticmethod
    def get_help_text():
        return _('Your password must contain at least 1 uppercase letter, A-Z.')  # pragma: no cover
