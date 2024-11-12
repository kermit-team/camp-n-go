from unittest import mock

from django.conf import settings
from django.template.loader import render_to_string
from django.test import TestCase
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from model_bakery import baker

from server.apps.account.generators import AccountEmailVerificationTokenGenerator
from server.apps.account.models import Account, AccountProfile
from server.business_logic.mailing.account.email_verification import AccountEmailVerificationMail
from server.services.consumer.enums import TaskNameEnum
from server.services.consumer.serializers.mailing import MailingSerializer


class AccountEmailVerificationMailTestCase(TestCase):
    mock_celery_app_path = 'server.business_logic.mailing.abstract.app'

    def setUp(self):
        self.account = baker.make(Account, _fill_optional=True)
        baker.make(AccountProfile, account=self.account, _fill_optional=True)

        self.token = AccountEmailVerificationMail._token_generator().make_token(user=self.account)

    @mock.patch(mock_celery_app_path)
    @mock.patch.object(AccountEmailVerificationTokenGenerator, 'make_token')
    def test_send(
        self,
        token_generator_mock,
        celery_app_mock,
    ):
        emails = [self.account.email]
        subject = str(AccountEmailVerificationMail._subject_template)
        token = 'some_token_example'
        uidb64 = urlsafe_base64_encode(force_bytes(self.account.identifier))
        verification_url = settings.FRONTEND_EMAIL_VERIFICATION_URL_SCHEMA.format(uidb64=uidb64, token=token)

        ctx = {
            'name': self.account.profile.short_name,
            'verification_url': verification_url,
        }
        message = render_to_string(AccountEmailVerificationMail._message_template, ctx)

        token_generator_mock.return_value = token

        AccountEmailVerificationMail.send(account=self.account)

        expected_payload = MailingSerializer(
            to_email=emails,
            subject=subject,
            html_message=message,
        )

        celery_app_mock.send_task.assert_called_once_with(
            name=TaskNameEnum.MAILING,
            kwargs=expected_payload.model_dump(),
        )
