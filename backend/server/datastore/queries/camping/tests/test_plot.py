from copy import deepcopy
from datetime import date, timedelta

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingPlot, CampingSection, PaymentStatus, Reservation
from server.datastore.queries.camping import CampingPlotQuery, ReservationQuery


class CampingPlotQueryTestCase(TestCase):
    def setUp(self):
        self.max_number_of_people = 10
        self.camping_section = baker.make(_model=CampingSection)
        self.camping_plots = baker.make(
            _model=CampingPlot,
            max_number_of_people=self.max_number_of_people,
            camping_section=self.camping_section,
            _quantity=4,
        )

    def test_get_available(self):
        number_of_people = self.max_number_of_people
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
        )

        self.assertCountEqual(result, self.camping_plots)

    def test_get_available_without_existing_camping_plots_for_given_number_of_people(self):
        number_of_people = self.max_number_of_people + 1
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
        )

        assert not result

    def test_get_available_when_each_camping_plot_has_reservation_in_given_dates(self):
        number_of_people = self.max_number_of_people
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        _reservation_for_whole_time = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=1),
            date_to=date_to + timedelta(days=1),
            camping_plot=self.camping_plots[0],
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
        )
        _reservation_for_first_days = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=1),
            date_to=date_from + timedelta(days=2),
            camping_plot=self.camping_plots[1],
            payment__status=PaymentStatus.WAITING_FOR_PAYMENT,
        )
        _reservation_for_last_days = baker.make(
            _model=Reservation,
            date_from=date_to - timedelta(days=2),
            date_to=date_to + timedelta(days=1),
            camping_plot=self.camping_plots[2],
            payment__status=PaymentStatus.PAID,
        )
        _reservation_between_dates = baker.make(
            _model=Reservation,
            date_from=date_from + timedelta(days=1),
            date_to=date_to - timedelta(days=1),
            camping_plot=self.camping_plots[3],
            payment__status=PaymentStatus.PAID,
        )

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
        )

        assert not result

    def test_get_available_when_each_camping_plot_has_cancelled_reservation_in_given_dates(self):
        number_of_people = self.max_number_of_people
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        _reservation_for_whole_time = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=1),
            date_to=date_to + timedelta(days=1),
            camping_plot=self.camping_plots[0],
            payment__status=PaymentStatus.CANCELLED,
        )
        _reservation_for_first_days = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=1),
            date_to=date_from + timedelta(days=2),
            camping_plot=self.camping_plots[1],
            payment__status=PaymentStatus.UNPAID,
        )
        _reservation_for_last_days = baker.make(
            _model=Reservation,
            date_from=date_to - timedelta(days=2),
            date_to=date_to + timedelta(days=1),
            camping_plot=self.camping_plots[2],
            payment__status=PaymentStatus.UNPAID,
        )
        _reservation_between_dates = baker.make(
            _model=Reservation,
            date_from=date_from + timedelta(days=1),
            date_to=date_to - timedelta(days=1),
            camping_plot=self.camping_plots[3],
            payment__status=PaymentStatus.REFUNDED,
        )

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
        )

        self.assertCountEqual(result, self.camping_plots)

    def test_get_available_when_each_camping_plot_has_not_disturbing_reservation(self):
        number_of_people = self.max_number_of_people
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        _reservation_before_date = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=7),
            date_to=date_from - timedelta(days=4),
            camping_plot=self.camping_plots[0],
            payment__status=ReservationQuery.cancellable_payments_statuses[0],
        )
        _reservation_at_arrival_date = baker.make(
            _model=Reservation,
            date_from=date_from - timedelta(days=7),
            date_to=date_from,
            camping_plot=self.camping_plots[1],
            payment__status=ReservationQuery.cancellable_payments_statuses[0],
        )
        _reservation_after_date = baker.make(
            _model=Reservation,
            date_from=date_to + timedelta(days=4),
            date_to=date_to + timedelta(days=7),
            camping_plot=self.camping_plots[2],
            payment__status=ReservationQuery.cancellable_payments_statuses[1],
        )
        _reservation_at_leaving_date = baker.make(
            _model=Reservation,
            date_from=date_to,
            date_to=date_to + timedelta(days=7),
            camping_plot=self.camping_plots[3],
            payment__status=ReservationQuery.cancellable_payments_statuses[1],
        )

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
        )

        self.assertCountEqual(result, self.camping_plots)

    def test_get_available_with_queryset(self):
        number_of_people = self.max_number_of_people
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)

        queryset = CampingPlot.objects.filter(id=self.camping_plots[0].id)

        result = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
            queryset=deepcopy(queryset),
        )

        self.assertCountEqual(result, queryset)

    def test_get_queryset(self):
        queryset = CampingPlotQuery.get_queryset()

        self.assertCountEqual(queryset, self.camping_plots)
