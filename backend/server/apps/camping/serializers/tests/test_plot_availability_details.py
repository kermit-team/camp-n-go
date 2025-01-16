from datetime import date
from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.plot_availability_details import CampingPlotAvailabilityDetailsSerializer
from server.datastore.queries.camping import ReservationQuery


class CampingPlotAvailabilityDetailsSerializerTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    number_of_adults = 1
    number_of_children = 2

    def setUp(self):
        self.camping_plot = baker.make(_model=CampingPlot, _fill_optional=True)

    @mock.patch.object(ReservationQuery, 'calculate_overall_price')
    def test_get_is_cancellable(self, calculate_reservation_overall_price_mock):
        serializer = CampingPlotAvailabilityDetailsSerializer(
            self.camping_plot,
            context={
                'request': mock.MagicMock(
                    data={
                        'date_from': self.date_from,
                        'date_to': self.date_to,
                        'number_of_adults': self.number_of_adults,
                        'number_of_children': self.number_of_children,
                    },
                ),
            },
        )
        serializer_data = serializer.data

        calculate_reservation_overall_price_mock.assert_called_once_with(
            date_from=self.date_from,
            date_to=self.date_to,
            number_of_adults=self.number_of_adults,
            number_of_children=self.number_of_children,
            camping_section=self.camping_plot.camping_section,
        )

        assert serializer_data.get('price') == calculate_reservation_overall_price_mock.return_value
