from celery.utils.log import get_task_logger
from django.conf import settings
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.utils.translation import gettext_lazy as _

from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account
from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum

logger = get_task_logger(__name__)


class AccountEmailVerificationMail(AbstractMailBL):
    _subject_template = _('AccountEmailVerificationEmailSubject')
    _message_template = 'mailing/account/email_verification.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_ACCOUNT_EMAIL_VERIFICATION_TO_MAIL.value
    _token_generator = AccountEmailVerificationTokenGenerator

    @classmethod
    def send(cls, account: Account) -> None:
        token = cls._token_generator().make_token(user=account)
        uidb64 = urlsafe_base64_encode(force_bytes(account.identifier))
        verification_url = settings.FRONTEND_EMAIL_VERIFICATION_URL_SCHEMA.format(uidb64=uidb64, token=token)

        subject = str(cls._subject_template)
        ctx = {
            'name': account.profile.short_name,
            'verification_url': verification_url,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[account.email],
        )
