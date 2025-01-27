from django.conf import settings
from django.template.loader import render_to_string
from django.utils import timezone
from django.utils.translation import gettext_lazy as _

from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum


class ContactFormMail(AbstractMailBL):
    _subject_template = _('ContactFormEmailSubject')
    _message_template = 'mailing/camping/contact_form.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_CONTACT_FORM_TO_MAIL.value

    @classmethod
    def send(cls, email: str, content: str) -> None:
        current_datetime = timezone.now()

        subject = str(cls._subject_template)
        ctx = {
            'email': email,
            'content': content,
            'datetime': current_datetime.strftime(settings.DATETIME_INPUT_FORMATS[0]),
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[settings.EMAIL_HOST_USER],
            from_email=email,
        )
