from django.conf import settings
from django.contrib.auth.models import Group, Permission
from django.db import transaction

from server.apps.account.exceptions.permission import PermissionNotExistsError
from server.business_logic.abstract import AbstractBL
from server.datastore.commands.account import GroupCommand
from server.datastore.queries.account import PermissionQuery


class LoadGroupsBL(AbstractBL):
    @classmethod
    @transaction.atomic
    def process(cls) -> None:
        for group_schema in settings.GROUPS:
            group, _ = GroupCommand.get_or_create(name=group_schema['NAME'])

            cls._set_permissions(group=group, permissions_schema=group_schema['PERMISSIONS'])

    @classmethod
    @transaction.atomic
    def _set_permissions(cls, group: Group, permissions_schema: list[str]) -> None:
        permissions = []
        for codename in permissions_schema:
            try:
                permission = PermissionQuery.get_by_codename(codename=codename)
            except Permission.DoesNotExist:
                raise PermissionNotExistsError(codename=codename)
            else:
                permissions.append(permission)

        group.permissions.set(permissions, clear=True)
