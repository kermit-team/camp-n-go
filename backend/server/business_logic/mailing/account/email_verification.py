from django.template.loader import render_to_string
from django.urls.base import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.utils.translation import gettext_lazy as _

from server.apps.account.models import Account
from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum
from server.utils.api import get_frontend_url


class AccountEmailVerificationMail(AbstractMailBL):
    _subject_template = _('AccountEmailVerificationEmailSubject')
    _message_template = 'mailing/account/email_verification.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_ACCOUNT_EMAIL_VERIFICATION_TO_MAIL.value

    @classmethod
    def send(cls, account: Account, token: str) -> None:
        uidb64 = urlsafe_base64_encode(force_bytes(account.identifier))

        url_path = reverse(viewname='account_email_verification', kwargs={'uidb64': uidb64, 'token': token})
        email_verification_url = get_frontend_url(backend_url_path=url_path)

        subject = str(cls._subject_template)
        ctx = {
            'name': account.profile.short_name,
            'email_verification_url': email_verification_url,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[account.email],
        )
