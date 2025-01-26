from enum import Enum

from django.utils.translation import gettext_lazy as _


class ContactFormMessagesEnum(Enum):
    CONTACT_FORM_SEND_SUCCESS = _('Contact form from email {email} has been successfully sent.')
