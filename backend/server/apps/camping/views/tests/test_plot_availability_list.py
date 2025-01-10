from datetime import date
from decimal import Decimal
from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.views import CampingPlotAvailabilityListView
from server.datastore.queries.camping import CampingPlotQuery


class CampingPlotAvailabilityListViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CampingPlotAvailabilityListView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.get_queryset')
    def test_request(self, mock_get_camping_plot_availability_list_queryset, mock_get_available_camping_plots):
        number_of_adults = 2
        number_of_children = 2
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)
        queryset = self.view.queryset.all()

        request_data = {
            'date_from': date_from,
            'date_to': date_to,
            'number_of_adults': number_of_adults,
            'number_of_children': number_of_children,
        }
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        mock_get_available_camping_plots.return_value = queryset
        url = reverse('camping_plot_availability_list')

        req = self.factory.get(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = {
            'count': mock_get_available_camping_plots.return_value.count(),
            'links': {
                'next': None,
                'previous': None,
            },
            'page': 1,
            'results': self.view.serializer_class(
                queryset,
                context={'request': req},
                many=True,
            ).data,
        }

        mock_get_available_camping_plots.assert_called_once()
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['number_of_people'] == Decimal(
            number_of_adults + number_of_children,
        )
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['date_from'] == date_from
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['date_to'] == date_to
        self.assertCountEqual(
            mock_get_available_camping_plots.call_args_list[0].kwargs['queryset'],
            queryset,
        )

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.get_queryset')
    def test_request_without_required_filters(
        self,
        mock_get_camping_plot_availability_list_queryset,
        mock_get_available_camping_plots,
    ):
        queryset = self.view.queryset.all()
        request_data = {}

        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        mock_get_available_camping_plots.return_value = queryset
        url = reverse('camping_plot_availability_list')

        req = self.factory.get(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        mock_get_available_camping_plots.assert_not_called()
        assert res.status_code == status.HTTP_400_BAD_REQUEST

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.get_queryset')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.pagination_class')
    def test_request_with_disabled_pagination(
        self,
        mock_pagination_class,
        mock_get_camping_plot_availability_list_queryset,
        mock_get_available_camping_plots,
    ):
        mock_pagination_class.return_value = None
        number_of_adults = 2
        number_of_children = 2
        date_from = date(2020, 1, 1)
        date_to = date(2020, 1, 8)
        queryset = self.view.queryset.all()

        request_data = {
            'date_from': date_from,
            'date_to': date_to,
            'number_of_adults': number_of_adults,
            'number_of_children': number_of_children,
        }
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        mock_get_available_camping_plots.return_value = queryset
        url = reverse('camping_plot_availability_list')

        req = self.factory.get(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            queryset,
            context={'request': req},
            many=True,
        ).data

        mock_get_available_camping_plots.assert_called_once()
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['number_of_people'] == Decimal(
            number_of_adults + number_of_children,
        )
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['date_from'] == date_from
        assert mock_get_available_camping_plots.call_args_list[0].kwargs['date_to'] == date_to
        self.assertCountEqual(
            mock_get_available_camping_plots.call_args_list[0].kwargs['queryset'],
            queryset,
        )

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.get_queryset')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.pagination_class')
    def test_request_with_disabled_pagination_and_without_required_filters(
        self,
        mock_pagination_class,
        mock_get_camping_plot_availability_list_queryset,
        mock_get_available_camping_plots,
    ):
        mock_pagination_class.return_value = None
        queryset = self.view.queryset.all()
        request_data = {}

        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        mock_get_available_camping_plots.return_value = queryset
        url = reverse('camping_plot_availability_list')

        req = self.factory.get(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req)

        mock_get_available_camping_plots.assert_not_called()
        assert res.status_code == status.HTTP_400_BAD_REQUEST
