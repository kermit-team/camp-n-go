from django.conf import settings
from django.template.loader import render_to_string
from django.utils.translation import gettext_lazy as _

from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum


class ContactFormConfirmationMail(AbstractMailBL):
    _subject_template = _('ContactFormConfirmationEmailSubject')
    _message_template = 'mailing/camping/contact_form_confirmation.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_CONTACT_FORM_CONFIRMATION_TO_MAIL.value

    @classmethod
    def send(cls, email: str) -> None:
        subject = str(cls._subject_template)
        ctx = {
            'contact_form_respond_time': settings.CONTACT_FORM_RESPOND_TIME,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[email],
        )
