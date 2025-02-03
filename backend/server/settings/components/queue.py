import os

from celery.schedules import crontab

from server.services.consumer.enums import TaskNameEnum

MAILING_QUEUE = os.getenv('MAILING_QUEUE', 'celery')

MAX_RETRIES = int(os.getenv('MAX_RETRIES', 5))
DEFAULT_TASK_RETRY_DELAY_IN_SECONDS = int(os.getenv('DEFAULT_TASK_RETRY_DELAY_IN_SECONDS', 5))

# Celery
celery_broker_url = os.getenv('CELERY_BROKER_URL')
celery_beat_scheduler = 'django_celery_beat.schedulers:DatabaseScheduler'
celery_beat_schedule = {
    'RunReservationsReminderDailyDispatch': {
        'task': TaskNameEnum.RESERVATIONS_REMINDER_DAILY_DISPATCHER,
        'schedule': crontab(
            *os.environ.get('RESERVATIONS_REMINDER_DAILY_DISPATCHER_TASK_SCHEDULE', '0 12 * * *').split(' '),
        ),
    },
}
