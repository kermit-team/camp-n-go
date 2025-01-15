from datetime import date, timedelta
from decimal import Decimal
from typing import Optional

from django.conf import settings
from django.db import transaction

from server.apps.account.models import Account
from server.apps.camping.models import CampingPlot, CampingSection, Payment, PaymentStatus, Reservation
from server.apps.car.models import Car
from server.business_logic.camping.stripe_payment import StripePaymentCreateCheckoutBL


class ReservationCommand:
    cancellable_payments_statuses = [
        PaymentStatus.WAITING_FOR_PAYMENT,
        PaymentStatus.PAID,
    ]

    @classmethod
    @transaction.atomic
    def create(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        user: Account,
        car: Car,
        camping_plot: CampingPlot,
        comments: Optional[str] = None,
    ) -> Reservation:
        stripe_checkout = StripePaymentCreateCheckoutBL.process(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            user=user,
            camping_plot=camping_plot,
        )

        payment = Payment.objects.create(
            stripe_checkout_id=stripe_checkout.id,
            price=cls.calculate_overall_price(
                date_from=date_from,
                date_to=date_to,
                number_of_adults=number_of_adults,
                number_of_children=number_of_children,
                camping_section=camping_plot.camping_section,
            ),
        )

        return Reservation.objects.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            comments=comments,
            user=user,
            car=car,
            camping_plot=camping_plot,
            payment=payment,
        )

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
