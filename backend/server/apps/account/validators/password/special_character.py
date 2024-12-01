import re
from typing import Optional

from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

from server.apps.account.models import Account


class SpecialCharacterValidator:
    @staticmethod
    def validate(password: str, user: Optional[Account] = None):
        if not re.findall(pattern=r'[()[\]{}|\\`~!@#$%^&*_\-+=;:\'",<>./?]', string=password):
            raise ValidationError(
                _(r'The password must contain at least 1 symbol: [()[\]{}|\\`~!@#$%^&*_\-+=;:\'",<>./?]'),
                code='password_no_symbol',
            )

    @staticmethod
    def get_help_text():
        return _(  # pragma: no cover
            r'Your password must contain at least 1 symbol: [()[\]{}|\\`~!@#$%^&*_\-+=;:\'",<>./?]',
        )
