from unittest import mock

from django.template.loader import render_to_string
from django.test import TestCase
from django.urls.base import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.business_logic.mailing.abstract import logger
from server.business_logic.mailing.account import AccountPasswordResetMail
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer
from server.utils.api import get_frontend_url
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class AccountPasswordResetMailTestCase(TestCase):
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
        subject = str(AccountPasswordResetMail._subject_template)
        token = 'some_token_example'
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))
        url_path = reverse(viewname='account_password_reset_confirm', kwargs={'uidb64': uidb64, 'token': token})
        password_reset_url = get_frontend_url(backend_url_path=url_path)

        ctx = {
            'name': self.account.profile.short_name,
            'password_reset_url': password_reset_url,
        }
        message = render_to_string(AccountPasswordResetMail._message_template, ctx)

        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            AccountPasswordResetMail.send(account=self.account, token=token)

            expected_log = get_formatted_log(
                msg=AccountPasswordResetMail._logger_message,
                level='INFO',
                logger=logger,
            )
            assert is_log_in_logstream(log=expected_log, output=context.output)

        expected_payload = MailingSerializer(
            to_email=emails,
            subject=subject,
            html_message=message,
        )

        celery_app_mock.send_task.assert_called_once_with(
            name=TaskNameEnum.MAILING,
            kwargs=expected_payload.model_dump(),
        )
