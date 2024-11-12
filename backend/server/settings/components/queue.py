import os

MAILING_QUEUE = os.getenv('MAILING_QUEUE', 'celery')

# Celery
celery_broker_url = os.getenv('CELERY_BROKER_URL')

MAX_RETRIES = int(os.getenv('MAX_RETRIES', 5))
DEFAULT_TASK_RETRY_DELAY_IN_SECONDS = int(os.getenv('DEFAULT_TASK_RETRY_DELAY_IN_SECONDS', 5))
