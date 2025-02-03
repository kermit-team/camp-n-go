from celery import Task
from celery.utils.log import get_task_logger
from django.conf import settings

from server.business_logic.exceptions import DatabaseConnectionError, DatabaseDataIntegrityError
from server.services.consumer.messages import ConsumerErrorMessages, ConsumerMessagesEnum

logger = get_task_logger(__name__)


class AbstractCeleryTask(Task):
    max_retries = settings.MAX_RETRIES
    default_retry_delay = settings.DEFAULT_TASK_RETRY_DELAY_IN_SECONDS
    autoretry_for = (
        DatabaseConnectionError,
        DatabaseDataIntegrityError,
    )

    def on_failure(self, exc, task_id, args, kwargs, einfo) -> None:  # noqa: WPS211
        logger.error(
            msg=ConsumerErrorMessages.FINISHED_WITH_FAILURE.value.format(
                name=self.name,
                task_id=task_id,
                exc=exc,
                einfo=einfo,
            ),
        )

    def on_success(self, retval, task_id, args, kwargs) -> None:
        logger.info(
            msg=ConsumerMessagesEnum.FINISHED_SUCCESSFULLY.value.format(
                name=self.name,
                task_id=task_id,
            ),
        )
