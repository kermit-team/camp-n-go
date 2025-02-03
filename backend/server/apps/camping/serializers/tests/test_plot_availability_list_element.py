from datetime import date
from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingPlot
from server.apps.camping.serializers.plot_availability_list_element import CampingPlotAvailabilityListElementSerializer


class CampingPlotAvailabilityListElementSerializerTestCase(TestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)

    number_of_adults = 1
    number_of_children = 2

    mock_metadata_serializer = (
        'server.apps.camping.serializers.plot_availability_list_element.CampingPlotAvailabilityMetadataSerializer'
    )

    def setUp(self):
        self.camping_plot = baker.make(_model=CampingPlot, _fill_optional=True)

    @mock.patch(mock_metadata_serializer)
    def test_get_metadata(self, metadata_serializer_mock):
        context = {
            'request': mock.MagicMock(
                query_params={
                    'date_from': self.date_from,
                    'date_to': self.date_to,
                    'number_of_adults': self.number_of_adults,
                    'number_of_children': self.number_of_children,
                },
            ),
        }

        serializer = CampingPlotAvailabilityListElementSerializer(self.camping_plot, context=context)
        serializer_data = serializer.data

        metadata_serializer_mock.assert_called_once_with(
            self.camping_plot,
            context=context,
        )

        assert serializer_data.get('metadata') == metadata_serializer_mock.return_value.data
