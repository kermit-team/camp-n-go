from server.apps.camping.models import CampingSection


class CampingSectionQuery:
    @classmethod
    def get_by_name(cls, name: str) -> CampingSection:
        return CampingSection.objects.get(name=name)
