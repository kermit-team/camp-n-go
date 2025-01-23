from unittest import mock

from django.conf import settings
from django.template.loader import render_to_string
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.business_logic.mailing.abstract import logger
from server.business_logic.mailing.camping import ContactFormConfirmationMail
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class ContactFormConfirmationMailTestCase(TestCase):
    mock_celery_app_path = 'server.business_logic.mailing.abstract.app'

    def setUp(self):
        self.account = baker.make(Account, _fill_optional=True)
        baker.make(AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch(mock_celery_app_path)
    def test_send(
        self,
        celery_app_mock,
    ):
        emails = [self.account.email]
        subject = str(ContactFormConfirmationMail._subject_template)

        ctx = {
            'contact_form_respond_time': settings.CONTACT_FORM_RESPOND_TIME,
        }
        message = render_to_string(ContactFormConfirmationMail._message_template, ctx)

        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            ContactFormConfirmationMail.send(email=self.account.email)

            expected_log = get_formatted_log(
                msg=ContactFormConfirmationMail._logger_message,
                level='INFO',
                logger=logger,
            )
            assert is_log_in_logstream(log=expected_log, output=context.output)

        expected_payload = MailingSerializer(
            to_email=emails,
            subject=subject,
            html_message=message,
            from_email=settings.EMAIL_HOST_USER,
        )

        celery_app_mock.send_task.assert_called_once_with(
            name=TaskNameEnum.MAILING,
            kwargs=expected_payload.model_dump(),
        )
