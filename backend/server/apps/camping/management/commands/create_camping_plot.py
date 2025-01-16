import argparse
from decimal import Decimal

from django.core.management.base import BaseCommand, CommandError

from server.apps.camping.exceptions.section import CampingSectionNotExistsError
from server.datastore.commands.camping import CampingPlotCommand


class Command(BaseCommand):
    help = 'Create camping plot based on the given details.'
    _command_args = [
        'position',
        'max_number_of_people',
        'width',
        'length',
        'water_connection',
        'electricity_connection',
        'is_shaded',
        'grey_water_discharge',
        'description',
        'camping_section_name',
    ]

    def add_arguments(self, parser):
        parser.add_argument(
            '--position',
            type=str,
            required=True,
            help="Camping plot's position",
        )
        parser.add_argument(
            '--max_number_of_people',
            type=int,
            required=True,
            help="Camping plot's max number of people",
        )
        parser.add_argument(
            '--width',
            type=Decimal,
            required=True,
            help="Camping plot's width (in metres)",
        )
        parser.add_argument(
            '--length',
            type=Decimal,
            required=True,
            help="Camping plot's length (in metres)",
        )
        parser.add_argument(
            '--camping_section_name',
            type=str,
            required=True,
            help="Camping plot's section name",
        )
        parser.add_argument(
            '--water_connection',
            action=argparse.BooleanOptionalAction,
            help='Camping plot has water connection',
        )
        parser.add_argument(
            '--electricity_connection',
            action=argparse.BooleanOptionalAction,
            help='Camping plot has electricity connection',
        )
        parser.add_argument(
            '--is_shaded',
            action=argparse.BooleanOptionalAction,
            help='Camping plot is shaded',
        )
        parser.add_argument(
            '--grey_water_discharge',
            action=argparse.BooleanOptionalAction,
            help='Camping plot has grey water discharge',
        )
        parser.add_argument(
            '--description',
            type=str,
            help="Camping plot's description",
        )

    def handle(self, *args, **kwargs):
        command_kwargs = {
            arg: value for arg, value in kwargs.items()
            if value is not None and arg in self._command_args
        }

        try:
            camping_plot = CampingPlotCommand.create(**command_kwargs)
        except CampingSectionNotExistsError as exc:
            raise CommandError(str(exc))

        self.stdout.write(
            'Successfully created camping plot: {camping_plot}.'.format(camping_plot=str(camping_plot)),
        )
