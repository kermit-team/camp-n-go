from smtplib import SMTPException
from unittest import mock

import pytest
from django.conf import settings
from django.test import TestCase

from server.business_logic.mailing.messages import MailingMessages
from server.services.consumer.exceptions import WrongPayloadError
from server.services.consumer.serializers.mailing import FileInfo
from server.services.consumer.tasks.mailing import MailingTask, logger
from server.utils.tests.helpers import get_formatted_log, is_log_in_logstream


class MailingTaskTestCase(TestCase):
    to_emails = ['email1@example.com', 'email2@example.com']
    subject = 'subject'
    html_message = '<p>message</p>'
    files = [
        FileInfo(path='path/to/file1.pdf', filename='file1.pdf'),
        FileInfo(path='path/to/file2.pdf', filename='file2.pdf'),
    ]
    data = 'data'

    email_mock_path = 'server.services.consumer.tasks.mailing.EmailMultiAlternatives'
    open_mock_path = 'builtins.open'

    @mock.patch(email_mock_path)
    def test_send_mail_success(self, email_mock):
        MailingTask().run(
            to_email=self.to_emails,
            subject=self.subject,
            html_message=self.html_message,
            from_email=settings.EMAIL_HOST_USER,
        )

        email_mock.return_value.attach_alternative.assert_called_with(self.html_message, 'text/html')
        email_mock.return_value.send.assert_called_with(fail_silently=False)
        email_mock.return_value.attach.assert_not_called()

    @mock.patch(open_mock_path, new_callable=mock.mock_open, read_data=data)
    @mock.patch(email_mock_path)
    def test_send_mail_with_attachments(self, email_mock, open_mock):
        MailingTask().run(
            to_email=self.to_emails,
            subject=self.subject,
            html_message=self.html_message,
            from_email=settings.EMAIL_HOST_USER,
            files=self.files,
        )

        expected_attachment_calls = [
            mock.call('file1.pdf', self.data),
            mock.call('file2.pdf', self.data),
        ]

        expected_open_calls = [
            mock.call(self.files[0].path, 'rb'),
            mock.call(self.files[1].path, 'rb'),
        ]

        email_mock.return_value.attach_alternative.assert_called_with(self.html_message, 'text/html')
        email_mock.return_value.send.assert_called_with(fail_silently=False)
        email_mock.return_value.attach.assert_has_calls(expected_attachment_calls)

        open_mock.assert_has_calls(expected_open_calls, any_order=True)

    def test_send_mail_no_receivers(self):
        with self.assertLogs(logger=logger.name, level='DEBUG') as context:
            MailingTask().run(
                to_email=[],
                subject=self.subject,
                html_message=self.html_message,
                from_email=settings.EMAIL_HOST_USER,
                files=self.files,
            )

            expected_log = get_formatted_log(
                msg=MailingMessages.NO_RECEIVERS,
                level='ERROR',
                logger=logger,
            )
            assert is_log_in_logstream(log=expected_log, output=context.output)

    @mock.patch(email_mock_path)
    def test_send_mail_smtp_error(self, email_mock):
        email_mock.return_value.send.side_effect = SMTPException

        with pytest.raises(SMTPException):
            MailingTask().run(
                to_email=self.to_emails,
                subject=self.subject,
                from_email=settings.EMAIL_HOST_USER,
                html_message=self.html_message,
            )

    @mock.patch(open_mock_path, side_effect=FileNotFoundError)
    @mock.patch(email_mock_path)
    def test_send_mail_file_does_not_exist(self, email_mock, open_mock):
        with pytest.raises(FileNotFoundError):
            MailingTask().run(
                to_email=self.to_emails,
                subject=self.subject,
                html_message=self.html_message,
                from_email=settings.EMAIL_HOST_USER,
                files=self.files,
            )

    @mock.patch(open_mock_path, side_effect=FileNotFoundError)
    @mock.patch(email_mock_path)
    def test_incorrect_payload(self, email_mock, open_mock):
        with pytest.raises(WrongPayloadError):
            MailingTask().run(
                to_email=10,
                subject=self.subject,
                html_message=self.html_message,
                from_email=settings.EMAIL_HOST_USER,
                files=self.files,
            )
