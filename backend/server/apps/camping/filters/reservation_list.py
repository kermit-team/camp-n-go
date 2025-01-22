import django_filters
from django.db.models import QuerySet

from server.apps.camping.models import Reservation
from server.datastore.queries.camping import ReservationQuery


class ReservationListFilter(django_filters.FilterSet):
    reservation_data = django_filters.CharFilter(method='filter_reservation_data')
    date_from = django_filters.DateFilter(field_name='date_to', lookup_expr='gte')
    date_to = django_filters.DateFilter(field_name='date_from', lookup_expr='lte')

    class Meta:
        model = Reservation
        fields = ['date_from', 'date_to']

    def filter_reservation_data(self, queryset: QuerySet, name: str, value: str) -> QuerySet:
        return ReservationQuery.get_with_matching_reservation_data(reservation_data=value, queryset=queryset)
