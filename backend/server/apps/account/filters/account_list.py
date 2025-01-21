import django_filters
from django.contrib.auth.models import Group
from django.db.models import QuerySet

from server.apps.account.models import Account
from server.datastore.queries.account import AccountQuery


class AccountListFilter(django_filters.FilterSet):
    personal_data = django_filters.CharFilter(method='filter_personal_data')
    group = django_filters.ModelChoiceFilter(field_name='groups', queryset=Group.objects.all())

    class Meta:
        model = Account
        fields = ['group']

    def filter_personal_data(self, queryset: QuerySet, name: str, value: str) -> QuerySet:
        return AccountQuery.get_with_matching_personal_data(personal_data=value, queryset=queryset)
