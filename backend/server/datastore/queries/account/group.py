from django.contrib.auth.models import Group
from django.db.models import QuerySet


class GroupQuery:
    @classmethod
    def get_by_name(cls, name: str) -> Group:
        return Group.objects.get(name=name)

    @classmethod
    def get_queryset(cls) -> QuerySet:
        return Group.objects.all().order_by('name')
