from datetime import date
from unittest import mock

from django.conf import settings
from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.plot_availability_metadata import CampingPlotAvailabilityMetadataSerializer
from server.datastore.queries.camping import ReservationQuery


class CampingPlotAvailabilityMetadataSerializerTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    number_of_adults = 1
    number_of_children = 2

    def setUp(self):
        self.camping_plot = baker.make(_model=CampingPlot, _fill_optional=True)

    @mock.patch.object(ReservationQuery, 'calculate_overall_price')
    @mock.patch.object(ReservationQuery, 'calculate_base_price')
    @mock.patch.object(ReservationQuery, 'calculate_adults_price')
    @mock.patch.object(ReservationQuery, 'calculate_children_price')
    def test_serializer_data(
        self,
        calculate_reservation_children_price_mock,
        calculate_reservation_adults_price_mock,
        calculate_reservation_base_price_mock,
        calculate_reservation_overall_price_mock,
    ):
        context = {
            'request': mock.MagicMock(
                query_params={
                    'date_from': self.date_from.strftime(settings.DATE_INPUT_FORMATS[0]),
                    'date_to': self.date_to.strftime(settings.DATE_INPUT_FORMATS[0]),
                    'number_of_adults': str(self.number_of_adults),
                    'number_of_children': str(self.number_of_children),
                },
            ),
        }

        expected_data = {
            'overall_price': calculate_reservation_overall_price_mock.return_value,
            'base_price': calculate_reservation_base_price_mock.return_value,
            'adults_price': calculate_reservation_adults_price_mock.return_value,
            'children_price': calculate_reservation_children_price_mock.return_value,
        }

        serializer = CampingPlotAvailabilityMetadataSerializer(self.camping_plot, context=context)
        serializer_data = serializer.data

        calculate_reservation_children_price_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_children=self.number_of_children,
            camping_section=self.camping_plot.camping_section,
        )
        calculate_reservation_adults_price_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            camping_section=self.camping_plot.camping_section,
        )
        calculate_reservation_base_price_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            camping_section=self.camping_plot.camping_section,
        )
        calculate_reservation_overall_price_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            camping_section=self.camping_plot.camping_section,
        )

        assert serializer_data == expected_data
