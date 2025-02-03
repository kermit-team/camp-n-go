from django.contrib.auth.models import Permission


class PermissionQuery:

    @classmethod
    def get_by_codename(cls, codename: str) -> Permission:
        return Permission.objects.get(codename=codename)
