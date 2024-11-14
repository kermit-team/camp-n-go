from argparse import BooleanOptionalAction

from django.core.management.base import BaseCommand

from server.datastore.commands.account import AccountCommand


class Command(BaseCommand):
    help = 'Create superuser account based on the given details.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--email',
            type=str,
            help="Account's email",
        )
        parser.add_argument(
            '--password',
            type=str,
            help='Password assigned to Account',
        )
        parser.add_argument(
            '--first_name',
            type=str,
            help="Account's first name",
        )
        parser.add_argument(
            '--last_name',
            type=str,
            help="Account's last name",
        )
        parser.add_argument(
            '--phone_number',
            type=str,
            required=False,
            help="Account's phone number",
        )
        parser.add_argument(
            '--id_card',
            type=str,
            required=False,
            help="Account's ID Card",
        )
        parser.add_argument(
            '--active',
            action=BooleanOptionalAction,
            default=False,
            help='Determines if Account is active',
        )

    def handle(self, *args, **kwargs):
        account = AccountCommand.create_superuser(
            email=kwargs.get('email'),
            password=kwargs.get('password'),
            first_name=kwargs.get('first_name'),
            last_name=kwargs.get('last_name'),
            phone_number=kwargs.get('phone_number'),
            id_card=kwargs.get('id_card'),
            is_active=kwargs.get('active'),
        )
        self.stdout.write(
            'Successfully created superuser account with identifier: {identifier}.'.format(
                identifier=account.identifier,
            ),
        )
