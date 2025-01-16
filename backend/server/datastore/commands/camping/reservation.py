from datetime import date
from typing import Any, Optional

from django.db import transaction

from server.apps.account.models import Account
from server.apps.camping.models import CampingPlot, Payment, Reservation
from server.apps.car.models import Car
from server.business_logic.camping.stripe_payment import StripePaymentCreateCheckoutBL
from server.datastore.queries.camping import ReservationQuery


class ReservationCommand:
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
            price=ReservationQuery.calculate_overall_price(
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
    def modify(cls, reservation: Reservation, **kwargs: Any) -> Reservation:
        for field, value in kwargs.items():
            setattr(reservation, field, value)

        reservation.save()
        return reservation
