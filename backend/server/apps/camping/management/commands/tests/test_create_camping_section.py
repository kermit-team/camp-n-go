from unittest import mock

import pytest
from django.core.management import call_command
from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingSection
from server.datastore.commands.camping import CampingSectionCommand


class CreateCampingSectionCommandTestCase(TestCase):
    def setUp(self):
        self.camping_section = baker.prepare(_model=CampingSection, _fill_optional=True)

    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(CampingSectionCommand, 'create')
    def test_create_camping_section_command_success(self, create_camping_section_mock):
        expected_message = 'Successfully created camping section with name: {name}.\n'.format(
            name=self.camping_section.name,
        )

        create_camping_section_mock.return_value = self.camping_section

        call_command(
            'create_camping_section',
            '--name',
            self.camping_section.name,
            '--base_price',
            self.camping_section.base_price,
            '--price_per_adult',
            self.camping_section.price_per_adult,
            '--price_per_child',
            self.camping_section.price_per_child,
        )
        captured = self.capsys.readouterr()

        create_camping_section_mock.assert_called_once_with(
            name=self.camping_section.name,
            base_price=self.camping_section.base_price,
            price_per_adult=self.camping_section.price_per_adult,
            price_per_child=self.camping_section.price_per_child,
        )
        assert captured.out == expected_message
