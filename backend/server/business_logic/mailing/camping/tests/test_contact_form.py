from unittest import mock

from django.conf import settings
from django.template.loader import render_to_string
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.business_logic.mailing.abstract import logger
from server.business_logic.mailing.camping import ContactFormMail
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class ContactFormMailTestCase(TestCase):
    mock_celery_app_path = 'server.business_logic.mailing.abstract.app'

    def setUp(self):
        self.account = baker.make(Account, _fill_optional=True)
        baker.make(AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch(mock_celery_app_path)
    def test_send(
        self,
        celery_app_mock,
    ):
        some_content = 'Some message content'
        from_email = self.account.email
        emails = [settings.EMAIL_HOST_USER]
        subject = str(ContactFormMail._subject_template)

        ctx = {
            'email': from_email,
            'content': some_content,
        }
        message = render_to_string(ContactFormMail._message_template, ctx)

        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            ContactFormMail.send(email=from_email, content=some_content)

            expected_log = get_formatted_log(
                msg=ContactFormMail._logger_message,
                level='INFO',
                logger=logger,
            )
            assert is_log_in_logstream(log=expected_log, output=context.output)

        expected_payload = MailingSerializer(
            to_email=emails,
            subject=subject,
            html_message=message,
            from_email=from_email,
        )

        celery_app_mock.send_task.assert_called_once_with(
            name=TaskNameEnum.MAILING,
            kwargs=expected_payload.model_dump(),
        )
