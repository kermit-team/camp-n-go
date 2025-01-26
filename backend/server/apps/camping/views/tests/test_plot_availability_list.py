from datetime import date
from decimal import Decimal
from unittest import mock

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase

from server.apps.camping.models import CampingPlot
from server.apps.camping.views import CampingPlotAvailabilityListView
from server.datastore.queries.camping import CampingPlotQuery
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class CampingPlotAvailabilityListViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    date_from = date(2020, 1, 1)
    date_to = date(2020, 1, 8)
    number_of_adults = 2
    number_of_children = 2

    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CampingPlotAvailabilityListView
        cls.viewname = 'camping_plot_availability_list'
        cls.view_permissions = AccountViewPermissions(
            anon=True,
            account=True,
            owner=True,
            employee=True,
            client=True,
        )

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(CampingPlotQuery, 'get_queryset')
    def test_request(self, mock_get_camping_plot_availability_list_queryset, get_available_camping_plots_mock):
        queryset = CampingPlot.objects.order_by('id')
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        get_available_camping_plots_mock.return_value = queryset

        request_data = {
            'date_from': self.date_from,
            'date_to': self.date_to,
            'number_of_adults': self.number_of_adults,
            'number_of_children': self.number_of_children,
        }
        url = reverse(self.viewname)

        req = self.factory.get(url, data=request_data)
        res = self.view.as_view()(req)

        expected_data = {
            'count': get_available_camping_plots_mock.return_value.count(),
            'links': {
                'next': None,
                'previous': None,
            },
            'page': 1,
            'results': self.view.serializer_class(
                get_available_camping_plots_mock.return_value,
                context={'request': req},
                many=True,
            ).data,
        }

        mock_get_camping_plot_availability_list_queryset.assert_called()
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['number_of_people'] == Decimal(
            self.number_of_adults + self.number_of_children,
        )
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['date_from'] == self.date_from
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['date_to'] == self.date_to
        self.assertCountEqual(
            get_available_camping_plots_mock.call_args_list[0].kwargs['queryset'],
            mock_get_camping_plot_availability_list_queryset.return_value,
        )

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(CampingPlotQuery, 'get_queryset')
    def test_request_without_required_filters(
        self,
        mock_get_camping_plot_availability_list_queryset,
        get_available_camping_plots_mock,
    ):
        queryset = CampingPlot.objects.order_by('id')
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        get_available_camping_plots_mock.return_value = queryset
        request_data = {}

        url = reverse(self.viewname)

        req = self.factory.get(url, data=request_data)
        res = self.view.as_view()(req)

        mock_get_camping_plot_availability_list_queryset.assert_called()
        get_available_camping_plots_mock.assert_not_called()
        assert res.status_code == status.HTTP_400_BAD_REQUEST

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(CampingPlotQuery, 'get_queryset')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.pagination_class')
    def test_request_with_disabled_pagination(
        self,
        pagination_class_mock,
        mock_get_camping_plot_availability_list_queryset,
        get_available_camping_plots_mock,
    ):
        queryset = CampingPlot.objects.order_by('id')
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        get_available_camping_plots_mock.return_value = queryset
        pagination_class_mock.return_value = None

        request_data = {
            'date_from': self.date_from,
            'date_to': self.date_to,
            'number_of_adults': self.number_of_adults,
            'number_of_children': self.number_of_children,
        }
        url = reverse(self.viewname)

        req = self.factory.get(url, data=request_data)
        res = self.view.as_view()(req)

        expected_data = self.view.serializer_class(
            get_available_camping_plots_mock.return_value,
            context={'request': req},
            many=True,
        ).data

        mock_get_camping_plot_availability_list_queryset.assert_called()
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['number_of_people'] == Decimal(
            self.number_of_adults + self.number_of_children,
        )
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['date_from'] == self.date_from
        assert get_available_camping_plots_mock.call_args_list[0].kwargs['date_to'] == self.date_to
        self.assertCountEqual(
            get_available_camping_plots_mock.call_args_list[0].kwargs['queryset'],
            mock_get_camping_plot_availability_list_queryset.return_value,
        )

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(CampingPlotQuery, 'get_queryset')
    @mock.patch('server.apps.camping.views.CampingPlotAvailabilityListView.pagination_class')
    def test_request_with_disabled_pagination_and_without_required_filters(
        self,
        pagination_class_mock,
        mock_get_camping_plot_availability_list_queryset,
        get_available_camping_plots_mock,
    ):
        queryset = CampingPlot.objects.order_by('id')
        mock_get_camping_plot_availability_list_queryset.return_value = queryset
        get_available_camping_plots_mock.return_value = queryset
        pagination_class_mock.return_value = None
        request_data = {}

        url = reverse(self.viewname)

        req = self.factory.get(url, data=request_data)
        res = self.view.as_view()(req)

        mock_get_camping_plot_availability_list_queryset.assert_called()
        get_available_camping_plots_mock.assert_not_called()
        assert res.status_code == status.HTTP_400_BAD_REQUEST

    @mock.patch.object(CampingPlotQuery, 'get_available')
    @mock.patch.object(CampingPlotQuery, 'get_queryset')
    def test_permissions(self, mock_get_camping_plot_availability_list_queryset, get_available_camping_plots_mock):
        self._create_accounts_with_groups_and_permissions()
        request_data = {
            'date_from': self.date_from,
            'date_to': self.date_to,
            'number_of_adults': self.number_of_adults,
            'number_of_children': self.number_of_children,
        }

        self._test_list_permissions(data=request_data)
