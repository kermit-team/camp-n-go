from datetime import date, timedelta
from unittest import mock

from django.conf import settings
from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection, PaymentStatus, Reservation
from server.apps.car.models import Car
from server.business_logic.camping.stripe_payment import StripePaymentCreateCheckoutBL
from server.datastore.commands.camping.reservation import ReservationCommand
from server.utils.tests.baker_generators import generate_password


class ReservationCommandTestCase(TestCase):
    given_date = date(2020, 1, 1)

    number_of_adults = 2
    number_of_children = 1

    def setUp(self):
        self.account = baker.make(_model=Account, password=generate_password(), _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.car = baker.make(_model=Car, _fill_optional=True)
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(
            _model=CampingPlot,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    @mock.patch.object(StripePaymentCreateCheckoutBL, 'process')
    def test_create(self, stripe_payment_create_checkout_mock):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)
        comments = 'Some comments'

        stripe_payment_create_checkout_mock.return_value = mock.MagicMock(id='stripe_checkout_id')

        reservation = ReservationCommand.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
            comments=comments,
        )

        stripe_payment_create_checkout_mock.assert_called_once_with(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            camping_plot=self.camping_plot,
        )

        assert reservation.date_from == date_from
        assert reservation.date_to == date_to
        assert reservation.number_of_adults == self.number_of_adults
        assert reservation.number_of_children == self.number_of_children
        assert reservation.comments == comments
        assert reservation.user == self.account
        assert reservation.car == self.car
        assert reservation.camping_plot == self.camping_plot

        assert reservation.payment
        assert reservation.payment.stripe_checkout_id == stripe_payment_create_checkout_mock.return_value.id
        assert reservation.payment.price == ReservationCommand.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )
        assert reservation.payment.status == PaymentStatus.WAITING_FOR_PAYMENT

    @mock.patch.object(StripePaymentCreateCheckoutBL, 'process')
    def test_create_without_optional_fields(self, stripe_payment_create_checkout_mock):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        stripe_payment_create_checkout_mock.return_value = mock.MagicMock(id='stripe_checkout_id')

        reservation = ReservationCommand.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            car=self.car,
            camping_plot=self.camping_plot,
        )

        stripe_payment_create_checkout_mock.assert_called_once_with(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            user=self.account,
            camping_plot=self.camping_plot,
        )

        assert reservation.date_from == date_from
        assert reservation.date_to == date_to
        assert reservation.number_of_adults == self.number_of_adults
        assert reservation.number_of_children == self.number_of_children
        assert reservation.comments is None
        assert reservation.user == self.account
        assert reservation.car == self.car
        assert reservation.camping_plot == self.camping_plot

        assert reservation.payment
        assert reservation.payment.stripe_checkout_id == stripe_payment_create_checkout_mock.return_value.id
        assert reservation.payment.price == ReservationCommand.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )
        assert reservation.payment.status == PaymentStatus.WAITING_FOR_PAYMENT

    def test_calculate_overall_price(self):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        number_of_days = (date_to - date_from).days
        expected_price = number_of_days * (
            self.camping_section.base_price +
            (self.number_of_adults * self.camping_section.price_per_adult) +
            (self.number_of_children * self.camping_section.price_per_child)
        )

        calculated_price = ReservationCommand.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )

        assert calculated_price == expected_price

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_payment_status_is_waiting_for_payment(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date
        date_to = cancellable_date + timedelta(days=3)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is True

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_payment_status_is_paid(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date
        date_to = cancellable_date + timedelta(days=3)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.PAID,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is True

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_payment_status_is_unpaid(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date
        date_to = cancellable_date + timedelta(days=3)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.UNPAID,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is False

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_payment_status_is_cancelled(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date
        date_to = cancellable_date + timedelta(days=3)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.CANCELLED,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is False

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_payment_status_is_returned(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date
        date_to = cancellable_date + timedelta(days=3)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.RETURNED,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is False

    @freeze_time(given_date)
    def test_is_reservation_cancellable_when_reservation_cancellation_period_passed(self):
        cancellable_date = self.given_date + timedelta(days=settings.RESERVATION_CANCELLATION_PERIOD)
        date_from = cancellable_date - timedelta(days=1)
        date_to = cancellable_date + timedelta(days=2)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationCommand.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is False
