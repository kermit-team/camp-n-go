from django.conf import settings
from django.template.loader import render_to_string
from django.utils.translation import gettext_lazy as _

from server.apps.camping.models import Reservation
from server.business_logic.mailing.abstract import AbstractMailBL
from server.services.consumer.messages import ConsumerMessagesEnum


class ReservationReminderMail(AbstractMailBL):
    _subject_template = _('ReservationReminderEmailSubject')
    _message_template = 'mailing/camping/reservation_reminder.html'
    _logger_message = ConsumerMessagesEnum.ENQUEUED_RESERVATION_REMINDER_TO_MAIL.value

    @classmethod
    def send(cls, reservation: Reservation) -> None:
        subject = str(cls._subject_template)
        ctx = {
            'name': reservation.user.profile.short_name,
            'camping_plot': str(reservation.camping_plot),
            'date_from': reservation.date_from,
            'date_to': reservation.date_to,
            'number_of_adults': reservation.number_of_adults,
            'number_of_children': reservation.number_of_children,
            'registration_plate': reservation.car.registration_plate,
            'check_in_time': settings.CHECK_IN_TIME,
            'check_out_time': settings.CHECK_OUT_TIME,
        }

        message = render_to_string(cls._message_template, ctx)

        cls._enqueue_files_to_mail(
            subject=subject,
            message=message,
            emails=[reservation.user.email],
        )
