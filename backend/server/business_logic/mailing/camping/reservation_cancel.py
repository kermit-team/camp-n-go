from django.conf import settings
from django.template.loader import render_to_string
from django.utils.translation import gettext_lazy as _

from server.apps.camping.models import Reservation
from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum


class ReservationCancelMail(AbstractMailBL):
    _subject_template = _('ReservationCancelEmailSubject')
    _message_template = 'mailing/camping/reservation_cancel.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_RESERVATION_CANCEL_TO_MAIL.value

    @classmethod
    def send(cls, reservation: Reservation) -> None:
        subject = str(cls._subject_template)
        ctx = {
            'name': reservation.user.profile.short_name,
            'reservation': reservation,
            'max_refund_time_in_days': settings.MAX_REFUND_TIME,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[reservation.user.email],
        )
