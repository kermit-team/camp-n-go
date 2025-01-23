from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.messages.contact_form import ContactFormMessagesEnum
from server.apps.camping.views import ContactFormSendView
from server.business_logic.mailing.camping import ContactFormConfirmationMail, ContactFormMail
from server.utils.tests.baker_generators import generate_password


class ContactFormSendViewTestCase(APITestCase):
    content = 'Some message content.'

    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ContactFormSendView

    def setUp(self):
        self.password = generate_password()
        self.account = baker.make(_model=Account, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(ContactFormConfirmationMail, 'send')
    @mock.patch.object(ContactFormMail, 'send')
    def test_request(self, send_contact_form_mail_mock, send_contact_form_confirmation_mail_mock):
        request_data = {
            'email': self.account.email,
            'content': self.content,
        }
        url = reverse('contact_form_send')

        req = self.factory.post(url, data=request_data)
        res = self.view.as_view()(req)

        expected_data = {
            'message': ContactFormMessagesEnum.CONTACT_FORM_SEND_SUCCESS.value.format(
                email=request_data['email'],
            ),
        }

        send_contact_form_mail_mock.assert_called_once_with(
            email=request_data['email'],
            content=request_data['content'],
        )
        send_contact_form_confirmation_mail_mock.assert_called_once_with(email=request_data['email'])

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data
