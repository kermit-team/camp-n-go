from django.contrib.auth.models import Group


class GroupCommand:

    @classmethod
    def get_or_create(cls, name: str) -> tuple[Group, bool]:
        return Group.objects.get_or_create(name=name)
