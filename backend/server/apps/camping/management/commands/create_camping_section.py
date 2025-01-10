from decimal import Decimal

from django.core.management.base import BaseCommand

from server.datastore.commands.camping import CampingSectionCommand


class Command(BaseCommand):
    help = 'Create camping section based on the given details.'
    _command_args = [
        'name',
        'base_price',
        'price_per_adult',
        'price_per_child',
    ]

    def add_arguments(self, parser):
        parser.add_argument(
            '--name',
            type=str,
            required=True,
            help="Camping section's name",
        )
        parser.add_argument(
            '--base_price',
            type=Decimal,
            required=True,
            help="Camping section's base price",
        )
        parser.add_argument(
            '--price_per_adult',
            type=Decimal,
            required=True,
            help="Camping section's price per adult",
        )
        parser.add_argument(
            '--price_per_child',
            type=Decimal,
            required=True,
            help="Camping section's price per child",
        )

    def handle(self, *args, **kwargs):
        command_kwargs = {
            arg: value for arg, value in kwargs.items()
            if value is not None and arg in self._command_args
        }

        camping_section = CampingSectionCommand.create(**command_kwargs)
        self.stdout.write(
            'Successfully created camping section with name: {name}.'.format(
                name=camping_section.name,
            ),
        )
