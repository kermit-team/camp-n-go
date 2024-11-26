from server.celery import app
from server.services.consumer.tasks.mailing import MailingTask

mailing_task = app.register_task(MailingTask())
