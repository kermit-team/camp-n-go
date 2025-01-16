from datetime import date, timedelta
from decimal import Decimal

from django.conf import settings

from server.apps.camping.models import CampingSection, PaymentStatus, Reservation


class ReservationQuery:
    cancellable_payments_statuses = [
        PaymentStatus.WAITING_FOR_PAYMENT,
        PaymentStatus.PAID,
    ]

    @classmethod
    def calculate_overall_price(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        camping_section: CampingSection,
    ) -> Decimal:
        number_of_days = (date_to - date_from).days
        return number_of_days * (
            camping_section.base_price +
            (number_of_adults * camping_section.price_per_adult) +
            (number_of_children * camping_section.price_per_child)
        )

    @classmethod
    def is_reservation_cancellable(cls, reservation: Reservation) -> bool:
        current_date = date.today()
        last_cancellable_date = reservation.date_from - timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        is_payment_status_cancellable = reservation.payment.status in cls.cancellable_payments_statuses

        return is_payment_status_cancellable and current_date <= last_cancellable_date
