from datetime import date, timedelta
from decimal import Decimal
from typing import Optional

from django.conf import settings
from django.db.models import Q, QuerySet

from server.apps.account.models import Account
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
    def calculate_base_price(
        cls,
        date_from: date,
        date_to: date,
        camping_section: CampingSection,
    ) -> Decimal:
        number_of_days = (date_to - date_from).days
        return number_of_days * camping_section.base_price

    @classmethod
    def calculate_adults_price(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        camping_section: CampingSection,
    ) -> Decimal:
        number_of_days = (date_to - date_from).days
        return number_of_days * camping_section.price_per_adult * number_of_adults

    @classmethod
    def calculate_children_price(
        cls,
        date_from: date,
        date_to: date,
        number_of_children: int,
        camping_section: CampingSection,
    ) -> Decimal:
        number_of_days = (date_to - date_from).days
        return number_of_days * camping_section.price_per_child * number_of_children

    @classmethod
    def is_reservation_cancellable(cls, reservation: Reservation) -> bool:
        current_date = date.today()
        last_cancellable_date = reservation.date_from - timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        is_payment_status_cancellable = reservation.payment.status in cls.cancellable_payments_statuses

        return is_payment_status_cancellable and current_date <= last_cancellable_date

    @classmethod
    def is_car_modifiable(cls, reservation: Reservation) -> bool:
        current_date = date.today()
        return current_date <= reservation.date_to

    @classmethod
    def get_queryset_for_account(cls, account: Account) -> QuerySet:
        return Reservation.objects.filter(user=account).order_by('-id')

    @classmethod
    def get_queryset(cls) -> QuerySet:
        return Reservation.objects.order_by('-id')

    @classmethod
    def get_with_matching_reservation_data(
        cls,
        reservation_data: str,
        queryset: Optional[QuerySet] = None,
    ) -> QuerySet:
        if not queryset:
            queryset = Reservation.objects.order_by('-id')

        return queryset.filter(
            Q(user__email__icontains=reservation_data) |
            Q(user__profile__first_name__icontains=reservation_data) |
            Q(user__profile__last_name__icontains=reservation_data) |
            Q(car__registration_plate__icontains=reservation_data),
        )

    @classmethod
    def get_incoming_reservations(cls, given_date: date) -> QuerySet:
        incoming_date = given_date + timedelta(days=settings.RESERVATIONS_REMINDER_DISPATCH_TIME)

        return Reservation.objects.filter(
            date_from=incoming_date,
            payment__status=PaymentStatus.PAID,
        ).order_by('-id')
