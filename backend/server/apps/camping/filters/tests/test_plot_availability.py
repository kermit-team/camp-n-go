from datetime import date
from unittest import mock

from django.test import TestCase

from server.apps.camping.filters.plot_availability import CampingPlotAvailabilityFilter
from server.apps.camping.models import CampingPlot
from server.datastore.queries.camping import CampingPlotQuery


class CampingPlotAvailabilityFilterTestCase(TestCase):
    @mock.patch.object(CampingPlotQuery, 'get_available')
    def test_filter_queryset(self, get_available_camping_plots_mock):
        number_of_adults = 2
        number_of_children = 2
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)
        queryset = CampingPlot.objects.all()

        availability_filter = CampingPlotAvailabilityFilter(
            data={
                'date_from': date_from,
                'date_to': date_to,
                'number_of_adults': number_of_adults,
                'number_of_children': number_of_children,
            },
            queryset=queryset,
        )
        assert availability_filter.is_valid()
        availability_filter.filter_queryset(queryset=queryset)

        get_available_camping_plots_mock.assert_called_once_with(
            number_of_people=number_of_adults + number_of_children,
            date_from=date_from,
            date_to=date_to,
            queryset=queryset,
        )

    @mock.patch.object(CampingPlotQuery, 'get_available')
    def test_filter_queryset_without_required_filters(self, get_available_camping_plots_mock):
        queryset = CampingPlot.objects.all()

        availability_filter = CampingPlotAvailabilityFilter(
            data={},
            queryset=queryset,
        )

        assert not availability_filter.is_valid()

        get_available_camping_plots_mock.assert_not_called()
