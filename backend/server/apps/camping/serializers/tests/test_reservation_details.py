from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import Reservation
from server.apps.camping.serializers import ReservationDetailsSerializer
from server.datastore.queries.camping import ReservationQuery


class ReservationDetailsSerializerTestCase(TestCase):

    def setUp(self):
        self.reservation = baker.make(_model=Reservation, _fill_optional=True)

    @mock.patch.object(ReservationQuery, 'is_reservation_cancellable')
    def test_get_is_cancellable(self, is_reservation_cancellable_mock):
        serializer = ReservationDetailsSerializer(self.reservation)
        serializer_data = serializer.data

        is_reservation_cancellable_mock.assert_called_once_with(reservation=self.reservation)

        assert serializer_data.get('is_cancellable') == is_reservation_cancellable_mock.return_value
