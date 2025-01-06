from argparse import BooleanOptionalAction

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError

from server.apps.account.exceptions.group import GroupNotExistsError
from server.datastore.commands.account import AccountCommand


class Command(BaseCommand):
    help = 'Create account based on the given details.'
    _command_args = [
        'email',
        'password',
        'first_name',
        'last_name',
        'phone_number',
        'id_card',
        'is_active',
        'group_names',
    ]

    def add_arguments(self, parser):
        parser.add_argument(
            '--email',
            type=str,
            required=True,
            help="Account's email",
        )
        parser.add_argument(
            '--password',
            type=str,
            required=True,
            help='Password assigned to Account',
        )
        parser.add_argument(
            '--first_name',
            type=str,
            required=True,
            help="Account's first name",
        )
        parser.add_argument(
            '--last_name',
            type=str,
            required=True,
            help="Account's last name",
        )
        parser.add_argument(
            '--phone_number',
            type=str,
            help="Account's phone number",
        )
        parser.add_argument(
            '--id_card',
            type=str,
            help="Account's ID Card",
        )
        parser.add_argument(
            '--is_active',
            action=BooleanOptionalAction,
            help='Determines if Account is active',
        )
        parser.add_argument(
            '--group_names',
            type=str,
            nargs='*',
            default=[],
            choices=[
                settings.OWNER,
                settings.EMPLOYEE,
                settings.CLIENT,
            ],
            help='List of groups assigned to Account',
        )

    def handle(self, *args, **kwargs):
        command_kwargs = {
            arg: value for arg, value in kwargs.items()
            if value is not None and arg in self._command_args
        }

        try:
            account = AccountCommand.create(**command_kwargs)
        except GroupNotExistsError as exc:
            raise CommandError(str(exc))
        self.stdout.write(
            'Successfully created account with identifier: {identifier}.'.format(
                identifier=account.identifier,
            ),
        )
