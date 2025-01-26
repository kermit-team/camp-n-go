from server.celery import app
from server.services.consumer.tasks.dispatchers import ReservationsReminderDailyDispatcherTask
from server.services.consumer.tasks.mailing import MailingTask

mailing_task = app.register_task(MailingTask())
reservations_reminder_daily_dispatcher_task = app.register_task(ReservationsReminderDailyDispatcherTask())
