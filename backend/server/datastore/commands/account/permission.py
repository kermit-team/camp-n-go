from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType


class PermissionCommand:

    @classmethod
    def get_or_create(
        cls,
        name: str,
        codename: str,
        content_type_model: str,
        content_type_app_label: str,
    ) -> tuple[Permission, bool]:
        content_type, _ = ContentType.objects.get_or_create(
            model=content_type_model,
            app_label=content_type_app_label,
        )
        return Permission.objects.get_or_create(
            name=name,
            content_type=content_type,
            codename=codename,
        )
