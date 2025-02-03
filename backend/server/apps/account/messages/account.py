from enum import Enum

from django.utils.translation import gettext_lazy as _


class AccountMessagesEnum(Enum):
    EMAIL_VERIFICATION_SUCCESS = _('Account with uidb64 {uidb64} has been successfully activated.')
    EMAIL_VERIFICATION_RESEND_SUCCESS = _('Activation process for account with e-mail {email} has been started.')
    PASSWORD_RESET_SUCCESS = _('Password reset process for account with e-mail {email} has been started.')
    PASSWORD_RESET_CONFIRM_SUCCESS = _('Password for account with uidb64 {uidb64} has been successfully reset.')
    ANONYMIZATION_SUCCESS = _('Account {identifier} has been successfully anonymized.')
