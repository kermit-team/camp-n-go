from datetime import date

from celery.utils.log import get_task_logger

from server.business_logic.dispatchers.abstract import AbstractDispatcher
from server.business_logic.mailing.camping import ReservationReminderMail
from server.datastore.queries.camping import ReservationQuery
from server.services.consumer.messages import ConsumerMessagesEnum

logger = get_task_logger(__name__)


class ReservationsReminderDailyDispatcher(AbstractDispatcher):

    def dispatch(self) -> None:
        current_day = date.today()
        reservations = ReservationQuery.get_incoming_reservations(given_date=current_day)

        for reservation in reservations:
            ReservationReminderMail.send(reservation=reservation)

        accounts = [reservation.user for reservation in reservations]
        logger.info(
            ConsumerMessagesEnum.ENQUEUED_RESERVATIONS_REMINDER_DISPATCH.format(accounts=accounts),  # type: ignore
        )
