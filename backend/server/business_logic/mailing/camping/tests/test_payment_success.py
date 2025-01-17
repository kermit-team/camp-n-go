from unittest import mock

from django.conf import settings
from django.template.loader import render_to_string
from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.business_logic.mailing.abstract import logger
from server.business_logic.mailing.camping import PaymentSuccessMail
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class PaymentSuccessMailTestCase(TestCase):
    mock_celery_app_path = 'server.business_logic.mailing.abstract.app'

    def setUp(self):
        self.account = baker.make(Account, _fill_optional=True)
        baker.make(AccountProfile, account=self.account, _fill_optional=True)
        self.reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)

    @mock.patch(mock_celery_app_path)
    def test_send(
        self,
        celery_app_mock,
    ):
        emails = [self.reservation.user.email]
        subject = str(PaymentSuccessMail._subject_template)

        ctx = {
            'name': self.account.profile.short_name,
            'reservation': self.reservation,
            'cancellation_time_in_days': settings.RESERVATION_CANCELLATION_PERIOD,
        }
        message = render_to_string(PaymentSuccessMail._message_template, ctx)

        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            PaymentSuccessMail.send(reservation=self.reservation)

            expected_log = get_formatted_log(
                msg=PaymentSuccessMail._logger_message,
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
