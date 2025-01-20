import stripe
from django.conf import settings
from django.template.loader import render_to_string
from django.utils.translation import gettext_lazy as _

from server.apps.camping.models import Reservation
from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum
from server.utils.api import get_time_str_from_seconds


class ReservationCreateMail(AbstractMailBL):
    stripe.api_key = settings.STRIPE_API_KEY

    _subject_template = _('ReservationCreateEmailSubject')
    _message_template = 'mailing/camping/reservation_create.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_RESERVATION_CREATE_TO_MAIL.value

    @classmethod
    def send(cls, reservation: Reservation) -> None:
        stripe_checkout_id = reservation.payment.stripe_checkout_id
        checkout_session = stripe.checkout.Session.retrieve(id=stripe_checkout_id)

        subject = str(cls._subject_template)
        ctx = {
            'name': reservation.user.profile.short_name,
            'camping_plot': str(reservation.camping_plot),
            'date_from': reservation.date_from,
            'date_to': reservation.date_to,
            'expiration_time': get_time_str_from_seconds(value=settings.CHECKOUT_EXPIRATION),
            'checkout_url': checkout_session.url,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[reservation.user.email],
        )
