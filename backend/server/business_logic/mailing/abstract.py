import logging
from abc import ABC, abstractmethod

from server.celery import app
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer

logger = logging.getLogger(__name__)


class AbstractMailBL(ABC):
    @classmethod
    @abstractmethod
    def send(cls, *args, **kwargs) -> None:
        raise NotImplementedError

    @property
    @abstractmethod
    def _subject_template(self) -> str:
        raise NotImplementedError

    @property
    @abstractmethod
    def _message_template(self) -> str:
        raise NotImplementedError

    @property
    @abstractmethod
    def _logger_message(self) -> str:
        raise NotImplementedError

    @classmethod
    def _enqueue_files_to_mail(cls, subject: str, message: str, emails: list[str]) -> None:
        payload_serializer = MailingSerializer(
            to_email=emails,
            subject=subject,
            html_message=message,
        )
        app.send_task(
            name=TaskNameEnum.MAILING,
            kwargs=payload_serializer.model_dump(),
        )
        logger.info(cls._logger_message)  # type: ignore
