from unittest import mock

import pytest
from django.core.management import CommandError, call_command
from django.test import TestCase
from model_bakery import baker

from server.apps.camping.errors.section import CampingSectionErrorMessagesEnum
from server.apps.camping.exceptions.section import CampingSectionNotExistsError
from server.apps.camping.models import CampingPlot, CampingSection
from server.datastore.commands.camping import CampingPlotCommand


class CreateCampingPlotCommandTestCase(TestCase):
    def setUp(self):
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.prepare(
            _model=CampingPlot,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    @pytest.fixture(autouse=True)
    def capsys_setter(self, capsys):
        self.capsys = capsys

    @mock.patch.object(CampingPlotCommand, 'create')
    def test_create_camping_plot_command_success(self, create_camping_plot_mock):
        expected_message = 'Successfully created camping plot: {camping_plot}.\n'.format(
            camping_plot=str(self.camping_plot),
        )

        create_camping_plot_mock.return_value = self.camping_plot

        call_command(
            'create_camping_plot',
            '--position',
            self.camping_plot.position,
            '--max_number_of_people',
            self.camping_plot.max_number_of_people,
            '--width',
            self.camping_plot.width,
            '--length',
            self.camping_plot.length,
            '--camping_section_name',
            self.camping_section.name,
            '--water_connection',
            '--electricity_connection',
            '--is_shaded',
            '--grey_water_discharge',
            '--description',
            self.camping_plot.description,
        )
        captured = self.capsys.readouterr()

        create_camping_plot_mock.assert_called_once_with(
            position=self.camping_plot.position,
            max_number_of_people=self.camping_plot.max_number_of_people,
            width=self.camping_plot.width,
            length=self.camping_plot.length,
            water_connection=True,
            electricity_connection=True,
            is_shaded=True,
            grey_water_discharge=True,
            description=self.camping_plot.description,
            camping_section_name=self.camping_section.name,
        )
        assert captured.out == expected_message

    @mock.patch.object(CampingPlotCommand, 'create')
    def test_create_camping_plot_command_without_optional_arguments(self, create_camping_plot_mock):
        expected_message = 'Successfully created camping plot: {camping_plot}.\n'.format(
            camping_plot=str(self.camping_plot),
        )

        create_camping_plot_mock.return_value = self.camping_plot

        call_command(
            'create_camping_plot',
            '--position',
            self.camping_plot.position,
            '--max_number_of_people',
            self.camping_plot.max_number_of_people,
            '--width',
            self.camping_plot.width,
            '--length',
            self.camping_plot.length,
            '--camping_section_name',
            self.camping_section.name,
        )
        captured = self.capsys.readouterr()

        create_camping_plot_mock.assert_called_once_with(
            position=self.camping_plot.position,
            max_number_of_people=self.camping_plot.max_number_of_people,
            width=self.camping_plot.width,
            length=self.camping_plot.length,
            camping_section_name=self.camping_section.name,
        )
        assert captured.out == expected_message

    @mock.patch.object(CampingPlotCommand, 'create')
    def test_create_camping_plot_command_with_not_existing_camping_section(self, create_camping_plot_mock):
        camping_section_name = 'not-existing-camping-section'
        create_camping_plot_mock.side_effect = CampingSectionNotExistsError(name=camping_section_name)

        with pytest.raises(
            CommandError,
            match=CampingSectionErrorMessagesEnum.NOT_EXISTS.value.format(name=camping_section_name),
        ):
            call_command(
                'create_camping_plot',
                '--position',
                self.camping_plot.position,
                '--max_number_of_people',
                self.camping_plot.max_number_of_people,
                '--width',
                self.camping_plot.width,
                '--length',
                self.camping_plot.length,
                '--camping_section_name',
                camping_section_name,
                '--water_connection',
                '--electricity_connection',
                '--is_shaded',
                '--grey_water_discharge',
                '--description',
                self.camping_plot.description,
            )

        create_camping_plot_mock.assert_called_once_with(
            position=self.camping_plot.position,
            max_number_of_people=self.camping_plot.max_number_of_people,
            width=self.camping_plot.width,
            length=self.camping_plot.length,
            water_connection=True,
            electricity_connection=True,
            is_shaded=True,
            grey_water_discharge=True,
            description=self.camping_plot.description,
            camping_section_name=camping_section_name,
        )
