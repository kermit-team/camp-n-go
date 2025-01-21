import django_filters
from django.db.models import QuerySet

from server.datastore.queries.camping import CampingPlotQuery


class CampingPlotAvailabilityFilter(django_filters.FilterSet):
    number_of_children = django_filters.NumberFilter(required=True)
    number_of_adults = django_filters.NumberFilter(required=True)
    date_from = django_filters.DateFilter(required=True)
    date_to = django_filters.DateFilter(required=True)

    def filter_queryset(self, queryset: QuerySet) -> QuerySet:
        number_of_children = self.form.cleaned_data['number_of_children']
        number_of_adults = self.form.cleaned_data['number_of_adults']
        number_of_people = number_of_children + number_of_adults

        return CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=self.form.cleaned_data['date_from'],
            date_to=self.form.cleaned_data['date_to'],
            queryset=queryset,
        )
