from celery.utils.log import get_task_logger
from django.conf import settings

from server.business_logic.dispatchers import ReservationsReminderDailyDispatcher
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.tasks.abstract import AbstractCeleryTask

logger = get_task_logger(__name__)


class ReservationsReminderDailyDispatcherTask(AbstractCeleryTask):
    name = TaskNameEnum.RESERVATIONS_REMINDER_DAILY_DISPATCHER
    queue = settings.MAILING_QUEUE

    def run(self, *args, **kwargs) -> None:
        ReservationsReminderDailyDispatcher(
            task_id=self.request.id,
        ).dispatch()
