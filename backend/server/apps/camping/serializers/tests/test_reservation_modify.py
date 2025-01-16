from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.account.models import Account
from server.apps.camping.models import Reservation
from server.apps.camping.serializers import ReservationModifyCarSerializer
from server.apps.car.models import Car
from server.business_logic.camping import ReservationModifyCarBL


class ReservationModifySerializerTestCase(TestCase):
    def setUp(self):
        self.account = baker.make(_model=Account)
        self.car = baker.make(_model=Car)
        self.car.drivers.add(self.account)
        self.reservation = baker.make(
            _model=Reservation,
            user=self.account,
            car=self.car,
            _fill_optional=True,
        )
        self.new_car = baker.make(_model=Car, _fill_optional=True)
        self.new_car.drivers.add(self.account)

    @mock.patch.object(ReservationModifyCarBL, 'process')
    def test_update(self, modify_reservation_mock):
        serializer = ReservationModifyCarSerializer(
            instance=self.reservation,
            data={
                'car': self.new_car.id,
            },
        )

        assert serializer.is_valid()
        serializer.save()

        modify_reservation_mock.assert_called_once_with(
            reservation=self.reservation,
            car=self.new_car,
        )

    @mock.patch.object(ReservationModifyCarBL, 'process')
    def test_partial_update(self, modify_reservation_mock):
        serializer = ReservationModifyCarSerializer(
            instance=self.reservation,
            data={
                'car': self.new_car.id,
            },
            partial=True,
        )

        assert serializer.is_valid()
        serializer.save()

        modify_reservation_mock.assert_called_once_with(
            reservation=self.reservation,
            car=self.new_car,
        )

    @mock.patch.object(ReservationModifyCarBL, 'process')
    def test_partial_update_without_car(self, modify_reservation_mock):
        serializer = ReservationModifyCarSerializer(
            instance=self.reservation,
            data={},
            partial=True,
        )

        assert serializer.is_valid()
        serializer.save()

        modify_reservation_mock.assert_called_once_with(
            reservation=self.reservation,
            car=None,
        )
