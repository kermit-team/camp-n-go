import uuid
from datetime import date, timedelta
from unittest import mock

from django.conf import settings
from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.camping.models import Reservation
from server.business_logic.dispatchers.reservations_reminder import ReservationsReminderDailyDispatcher, logger
from server.business_logic.mailing.camping import ReservationReminderMail
from server.datastore.queries.camping import ReservationQuery
from server.services.consumer.messages import ConsumerMessagesEnum
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class ReservationsReminderDailyDispatcherTestCase(TestCase):
    given_date = date(2020, 1, 1)

    def setUp(self):
        self.reservation = baker.make(
            _model=Reservation,
            date_from=self.given_date + timedelta(days=settings.RESERVATIONS_REMINDER_DISPATCH_TIME),
            date_to=self.given_date + timedelta(days=settings.RESERVATIONS_REMINDER_DISPATCH_TIME + 7),
        )

    @freeze_time(given_date)
    @mock.patch.object(ReservationReminderMail, 'send')
    @mock.patch.object(ReservationQuery, 'get_incoming_reservations')
    def test_process(
        self,
        get_incoming_reservations_mock,
        send_reservation_reminder_mail_mock,
    ):
        queryset = Reservation.objects.all()
        get_incoming_reservations_mock.return_value = queryset
        task_id = uuid.uuid4()
        expected_accounts = [self.reservation.user]

        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            ReservationsReminderDailyDispatcher(task_id=task_id).dispatch()

            expected_log = get_formatted_log(
                msg=ConsumerMessagesEnum.ENQUEUED_RESERVATIONS_REMINDER_DISPATCH.format(
                    accounts=expected_accounts,
                ),
                level='INFO',
                logger=logger,
            )
            assert is_log_in_logstream(log=expected_log, output=context.output)

        get_incoming_reservations_mock.assert_called_once_with(given_date=self.given_date)
        send_reservation_reminder_mail_mock.assert_called_once_with(
            reservation=self.reservation,
        )
