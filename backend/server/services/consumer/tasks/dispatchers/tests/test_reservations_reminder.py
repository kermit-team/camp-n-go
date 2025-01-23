from unittest import mock

from django.test import TestCase

from server.services.consumer.tasks import ReservationsReminderDailyDispatcherTask


class ReservationsReminderDailyDispatcherTaskTestCase(TestCase):
    mock_reservations_reminder_daily_dispatcher = (
        'server.services.consumer.tasks.dispatchers.reservations_reminder.ReservationsReminderDailyDispatcher'
    )

    @mock.patch(mock_reservations_reminder_daily_dispatcher)
    def test_run(self, reservations_reminder_daily_dispatcher_mock):
        reservations_reminder_daily_dispatcher_task = ReservationsReminderDailyDispatcherTask()
        reservations_reminder_daily_dispatcher_task.run()

        reservations_reminder_daily_dispatcher_mock.assert_called_once_with(
            task_id=reservations_reminder_daily_dispatcher_task.request.id,
        )
        reservations_reminder_daily_dispatcher_mock.return_value.dispatch.assert_called_once()
