from typing import Optional

from celery.utils.log import get_task_logger
from django.conf import settings
from django.core.mail import EmailMultiAlternatives
from django.utils.html import strip_tags
from pydantic import ValidationError

from server.business_logic.mailing.messages import MailingMessages
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.exceptions import WrongPayloadError
from server.services.consumer.serializers.mailing import FileInfo, MailingSerializer
from server.services.consumer.tasks.abstract import AbstractCeleryTask

logger = get_task_logger(__name__)


class MailingTask(AbstractCeleryTask):
    name = TaskNameEnum.MAILING
    queue = settings.MAILING_QUEUE

    payload_serializer = MailingSerializer  # type: ignore

    def run(
        self,
        to_email: list[str],
        subject: str,
        html_message: str,
        from_email: str,
        files: Optional[list[FileInfo]] = None,
        *args,
        **kwargs,
    ) -> None:
        payload = self._validate(
            to_email=to_email,
            subject=subject,
            html_message=html_message,
            from_email=from_email,
            files=files,
        )

        if not payload.to_email:
            logger.error(MailingMessages.NO_RECEIVERS)
            return

        plain_message = strip_tags(payload.html_message)
        mail = EmailMultiAlternatives(
            from_email=from_email,
            to=payload.to_email,
            subject=payload.subject,
            body=plain_message,
        )
        mail.attach_alternative(payload.html_message, 'text/html')

        if payload.files:
            self._attach_files(mail=mail, files=payload.files)

        mail.send(fail_silently=False)

    @classmethod
    def _validate(
        cls,
        to_email: list[str],
        subject: str,
        html_message: str,
        from_email: str,
        files: Optional[list[FileInfo]] = None,
    ) -> MailingSerializer:
        try:
            return cls.payload_serializer(
                to_email=to_email,
                subject=subject,
                html_message=html_message,
                from_email=from_email,
                files=files,
            )
        except (ValidationError, TypeError) as exc:
            raise WrongPayloadError(details=str(exc))

    @classmethod
    def _attach_files(cls, mail: EmailMultiAlternatives, files: list[FileInfo]) -> None:
        for file in files:
            with open(file.path, 'rb') as fp:
                mail.attach(file.filename, fp.read())
