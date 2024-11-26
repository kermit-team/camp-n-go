import os

from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'server.settings')

app = Celery('server')
app.config_from_object('server.settings.components.queue', namespace='celery')

app.conf.update(
    worker_hijack_root_logger=False,
)
