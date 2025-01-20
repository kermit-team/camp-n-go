from datetime import date, timedelta

from django.conf import settings
from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection, PaymentStatus, Reservation
from server.apps.car.models import Car
from server.datastore.queries.camping import ReservationQuery
from server.utils.tests.baker_generators import generate_password


class ReservationQueryTestCase(TestCase):
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

    def test_calculate_overall_price(self):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        number_of_days = (date_to - date_from).days
        expected_price = number_of_days * (
            self.camping_section.base_price +
            (self.number_of_adults * self.camping_section.price_per_adult) +
            (self.number_of_children * self.camping_section.price_per_child)
        )

        calculated_price = ReservationQuery.calculate_overall_price(
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )

        assert calculated_price == expected_price

    def test_calculate_base_price(self):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        number_of_days = (date_to - date_from).days
        expected_price = number_of_days * self.camping_section.base_price

        calculated_price = ReservationQuery.calculate_base_price(
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )

        assert calculated_price == expected_price

    def test_calculate_adults_price(self):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        number_of_days = (date_to - date_from).days
        expected_price = number_of_days * self.number_of_adults * self.camping_section.price_per_adult

        calculated_price = ReservationQuery.calculate_adults_price(
            number_of_adults=self.number_of_adults,
            date_from=date_from,
            date_to=date_to,
            camping_section=self.camping_section,
        )

        assert calculated_price == expected_price

    def test_calculate_children_price(self):
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        number_of_days = (date_to - date_from).days
        expected_price = number_of_days * self.number_of_children * self.camping_section.price_per_child

        calculated_price = ReservationQuery.calculate_children_price(
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

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
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

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
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

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
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

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
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
            payment__status=PaymentStatus.REFUNDED,
            _fill_optional=True,
        )

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
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

        is_reservation_cancellable = ReservationQuery.is_reservation_cancellable(reservation=reservation)
        assert is_reservation_cancellable is False

    @freeze_time(given_date)
    def test_is_car_modifiable(self):
        modifiable_date = self.given_date
        date_from = modifiable_date - timedelta(days=7)
        date_to = modifiable_date

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
            _fill_optional=True,
        )

        is_car_modifiable = ReservationQuery.is_car_modifiable(reservation=reservation)
        assert is_car_modifiable is True

    def test_is_car_modifiable_when_reservation_in_past(self):
        modifiable_date = self.given_date
        date_from = modifiable_date - timedelta(days=7)
        date_to = modifiable_date - timedelta(days=1)

        reservation = baker.make(
            _model=Reservation,
            date_from=date_from,
            date_to=date_to,
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
            _fill_optional=True,
        )

        is_car_modifiable = ReservationQuery.is_car_modifiable(reservation=reservation)
        assert is_car_modifiable is False

    def test_get_queryset_for_account(self):
        user_reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)
        another_reservation = baker.make(_model=Reservation, _fill_optional=True)

        queryset = ReservationQuery.get_queryset_for_account(account=self.account)

        assert queryset.count() == 1
        assert user_reservation in set(queryset)
        assert another_reservation not in set(queryset)
