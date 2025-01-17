import stripe
from django.conf import settings

from server.apps.camping.exceptions.reservation import ReservationCannotBeCancelledError
from server.apps.camping.models import PaymentStatus, Reservation
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.camping import ReservationCancelMail
from server.datastore.commands.camping import PaymentCommand
from server.datastore.queries.camping import ReservationQuery


class ReservationCancelBL(AbstractBL):
    stripe.api_key = settings.STRIPE_API_KEY

    @classmethod
    def process(cls, reservation: Reservation) -> None:
        if not ReservationQuery.is_reservation_cancellable(reservation=reservation):
            raise ReservationCannotBeCancelledError(reservation_id=reservation.id)

        payment = PaymentCommand.modify(payment=reservation.payment, status=PaymentStatus.CANCELLED)

        checkout_session = stripe.checkout.Session.retrieve(id=payment.stripe_checkout_id)
        stripe.Refund.create(payment_intent=checkout_session.payment_intent)

        ReservationCancelMail.send(reservation=reservation)
