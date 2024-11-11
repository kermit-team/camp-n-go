from django.contrib.auth.models import Group


class GroupQuery:
    @classmethod
    def get_by_name(cls, name: str) -> Group:
        return Group.objects.get(name=name)
