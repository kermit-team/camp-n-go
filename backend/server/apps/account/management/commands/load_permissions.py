from django.core.management.base import BaseCommand

from server.business_logic.account.load_permissions import LoadPermissionsBL


class Command(BaseCommand):
    help = 'Fill database with defined permissions.'

    def handle(self, *args, **kwargs):
        LoadPermissionsBL.process()

        self.stdout.write('Successfully added permissions.')
