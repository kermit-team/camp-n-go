from django.core.management.base import BaseCommand, CommandError

from server.apps.account.exceptions.permission import PermissionNotExistsError
from server.business_logic.account import LoadGroupsBL


class Command(BaseCommand):
    help = 'Fill database with defined groups and associated permissions.'

    def handle(self, *args, **kwargs):
        try:
            LoadGroupsBL.process()
        except PermissionNotExistsError as exc:
            raise CommandError(str(exc))

        self.stdout.write('Successfully added groups.')
