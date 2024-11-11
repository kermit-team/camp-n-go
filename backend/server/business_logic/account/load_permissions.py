from django.conf import settings
from django.db import transaction

from server.business_logic.abstract import AbstractBL
from server.datastore.commands.account.permission import PermissionCommand


class LoadPermissionsBL(AbstractBL):
    @classmethod
    @transaction.atomic
    def process(cls) -> None:
        for permission_schema in settings.PERMISSIONS:
            PermissionCommand.get_or_create(
                name=permission_schema['NAME'],
                codename=permission_schema['CODENAME'],
                content_type_model=permission_schema['CONTENT_TYPE_MODEL'],
                content_type_app_label=permission_schema['CONTENT_TYPE_APP_LABEL'],
            )
