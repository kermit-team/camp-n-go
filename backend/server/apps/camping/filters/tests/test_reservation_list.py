from datetime import date, timedelta
from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.filters import ReservationListFilter
from server.apps.camping.models import Reservation
from server.datastore.queries.camping import ReservationQuery


class ReservationListFilterTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    def setUp(self):
        self.reservation_before_dates = baker.make(
            _model=Reservation,
            date_from=self.date_from - timedelta(days=7),
            date_to=self.date_from - timedelta(days=1),
        )
        self.reservation_after_date_from = baker.make(
            _model=Reservation,
            date_from=self.date_from - timedelta(days=7),
            date_to=self.date_from + timedelta(days=1),
        )
        self.reservation_between_dates = baker.make(
            _model=Reservation,
            date_from=self.date_from + timedelta(days=1),
            date_to=self.date_to - timedelta(days=1),
        )
        self.reservation_before_date_to = baker.make(
            _model=Reservation,
            date_from=self.date_to - timedelta(days=1),
            date_to=self.date_to + timedelta(days=7),
        )
        self.reservation_after_dates = baker.make(
            _model=Reservation,
            date_from=self.date_to + timedelta(days=1),
            date_to=self.date_to + timedelta(days=7),
        )

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    def test_filter_queryset(self, get_with_matching_reservation_data_mock):
        queryset = Reservation.objects.all()
        expected_queryset = queryset.filter(date_from__lte=self.date_to, date_to__gte=self.date_from)
        get_with_matching_reservation_data_mock.return_value = expected_queryset
        expected_reservations = [
            self.reservation_after_date_from,
            self.reservation_between_dates,
            self.reservation_before_date_to,
        ]

        reservation_filter = ReservationListFilter(
            data={
                'date_from': self.date_from,
                'date_to': self.date_to,
                'reservation_data': 'abc',
            },
            queryset=queryset,
        )
        assert reservation_filter.is_valid()
        results = reservation_filter.filter_queryset(queryset=queryset)

        get_with_matching_reservation_data_mock.assert_called_once()
        assert get_with_matching_reservation_data_mock.call_args_list[0].kwargs['reservation_data'] == 'abc'
        self.assertCountEqual(
            get_with_matching_reservation_data_mock.call_args_list[0].kwargs['queryset'],
            expected_queryset,
        )
        self.assertCountEqual(results, expected_reservations)

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    def test_filter_queryset_without_date_to(self, get_with_matching_reservation_data_mock):
        queryset = Reservation.objects.all()
        expected_queryset = queryset.filter(date_to__gte=self.date_from)
        get_with_matching_reservation_data_mock.return_value = expected_queryset
        expected_reservations = [
            self.reservation_after_date_from,
            self.reservation_between_dates,
            self.reservation_before_date_to,
            self.reservation_after_dates,
        ]

        reservation_filter = ReservationListFilter(
            data={
                'date_from': self.date_from,
                'reservation_data': 'abc',
            },
            queryset=queryset,
        )
        assert reservation_filter.is_valid()
        results = reservation_filter.filter_queryset(queryset=queryset)

        get_with_matching_reservation_data_mock.assert_called_once()
        assert get_with_matching_reservation_data_mock.call_args_list[0].kwargs['reservation_data'] == 'abc'
        self.assertCountEqual(
            get_with_matching_reservation_data_mock.call_args_list[0].kwargs['queryset'],
            expected_queryset,
        )
        self.assertCountEqual(results, expected_reservations)

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    def test_filter_queryset_without_date_from(self, get_with_matching_reservation_data_mock):
        queryset = Reservation.objects.all()
        expected_queryset = queryset.filter(date_from__lte=self.date_to)
        get_with_matching_reservation_data_mock.return_value = expected_queryset
        expected_reservations = [
            self.reservation_before_dates,
            self.reservation_after_date_from,
            self.reservation_between_dates,
            self.reservation_before_date_to,
        ]

        reservation_filter = ReservationListFilter(
            data={
                'date_to': self.date_to,
                'reservation_data': 'abc',
            },
            queryset=queryset,
        )
        assert reservation_filter.is_valid()
        results = reservation_filter.filter_queryset(queryset=queryset)

        get_with_matching_reservation_data_mock.assert_called_once()
        assert get_with_matching_reservation_data_mock.call_args_list[0].kwargs['reservation_data'] == 'abc'
        self.assertCountEqual(
            get_with_matching_reservation_data_mock.call_args_list[0].kwargs['queryset'],
            expected_queryset,
        )
        self.assertCountEqual(results, expected_reservations)

    @mock.patch.object(ReservationQuery, 'get_with_matching_reservation_data')
    def test_filter_queryset_without_reservation_data(self, get_with_matching_reservation_data_mock):
        queryset = Reservation.objects.all()
        expected_reservations = [
            self.reservation_after_date_from,
            self.reservation_between_dates,
            self.reservation_before_date_to,
        ]

        reservation_filter = ReservationListFilter(
            data={
                'date_from': self.date_from,
                'date_to': self.date_to,
            },
            queryset=queryset,
        )
        assert reservation_filter.is_valid()
        results = reservation_filter.filter_queryset(queryset=queryset)

        get_with_matching_reservation_data_mock.assert_not_called()
        self.assertCountEqual(results, expected_reservations)
