from django.db.models import QuerySet

from server.apps.camping.models import CampingSection


class CampingSectionQuery:
    @classmethod
    def get_by_name(cls, name: str) -> CampingSection:
        return CampingSection.objects.get(name=name)

    @classmethod
    def get_queryset(cls) -> QuerySet:
        return CampingSection.objects.order_by('name')
