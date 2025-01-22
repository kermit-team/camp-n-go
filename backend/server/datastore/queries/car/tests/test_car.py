from datetime import date, timedelta

from django.test import TestCase
from freezegun import freeze_time
from model_bakery import baker

from server.apps.account.models import Account
from server.apps.camping.models import PaymentStatus, Reservation
from server.apps.car.models import Car
from server.datastore.queries.car import CarQuery


class CarQueryTestCase(TestCase):
    given_date = date(2020, 1, 1)

    def setUp(self):
        self.car = baker.make(_model=Car)

    def test_get_by_registration_plate(self):
        registration_plate = self.car.registration_plate

        car = CarQuery.get_by_registration_plate(registration_plate=registration_plate)

        assert car

    def test_get_by_registration_plate_without_existing_car(self):
        registration_plate = 'not_existing_registration_plate'

        with self.assertRaises(Car.DoesNotExist):
            CarQuery.get_by_registration_plate(registration_plate=registration_plate)

    def test_car_belongs_to_user(self):
        user = baker.make(_model=Account)
        self.car.drivers.add(user)

        result = CarQuery.car_belongs_to_user(car=self.car, user=user)
        assert result is True

    def test_car_belongs_to_user_when_car_not_belongs_to_user(self):
        user = baker.make(_model=Account)

        result = CarQuery.car_belongs_to_user(car=self.car, user=user)
        assert result is False

    @freeze_time(given_date)
    def test_is_car_able_to_enter_at_the_beginning_of_the_reservation(self):
        baker.make(
            _model=Reservation,
            date_from=self.given_date,
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.PAID,
        )

        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is True

    @freeze_time(given_date)
    def test_is_car_able_to_enter_at_the_end_of_the_reservation(self):
        baker.make(
            _model=Reservation,
            date_from=self.given_date - timedelta(days=7),
            date_to=self.given_date,
            car=self.car,
            payment__status=PaymentStatus.PAID,
        )

        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is True

    @freeze_time(given_date)
    def test_is_car_able_to_enter_before_the_reservation(self):
        baker.make(
            _model=Reservation,
            date_from=self.given_date + timedelta(days=1),
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.PAID,
        )

        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is False

    @freeze_time(given_date)
    def test_is_car_able_to_enter_after_the_reservation(self):
        baker.make(
            _model=Reservation,
            date_from=self.given_date - timedelta(days=7),
            date_to=self.given_date - timedelta(days=1),
            car=self.car,
            payment__status=PaymentStatus.PAID,
        )

        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is False

    @freeze_time(given_date)
    def test_is_car_able_to_enter_when_reservation_has_wrong_status(self):
        baker.make(
            _model=Reservation,
            date_from=self.given_date,
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
        )
        baker.make(
            _model=Reservation,
            date_from=self.given_date,
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.UNPAID,
        )
        baker.make(
            _model=Reservation,
            date_from=self.given_date,
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.CANCELLED,
        )
        baker.make(
            _model=Reservation,
            date_from=self.given_date,
            date_to=self.given_date + timedelta(days=7),
            car=self.car,
            payment__status=PaymentStatus.REFUNDED,
        )

        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is False

    @freeze_time(given_date)
    def test_is_car_able_to_enter_without_existing_reservation(self):
        result = CarQuery.is_car_able_to_enter(registration_plate=self.car.registration_plate)
        assert result is False
