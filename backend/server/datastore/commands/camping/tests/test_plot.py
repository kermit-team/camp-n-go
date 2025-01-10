from django.test import TestCase
from model_bakery import baker

from server.apps.camping.exceptions.section import CampingSectionNotExistsError
from server.apps.camping.models import CampingPlot, CampingSection
from server.datastore.commands.camping.plot import CampingPlotCommand


class CampingPlotCommandTestCase(TestCase):

    def setUp(self):
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.prepare(
            _model=CampingPlot,
            camping_section=self.camping_section,
            _fill_optional=True,
        )

    def test_create_camping_plot(self):
        camping_plot = CampingPlotCommand.create(
            position=self.camping_plot.position,
            max_number_of_people=self.camping_plot.max_number_of_people,
            width=self.camping_plot.width,
            length=self.camping_plot.length,
            camping_section_name=self.camping_section.name,
            water_connection=self.camping_plot.water_connection,
            electricity_connection=self.camping_plot.electricity_connection,
            is_shaded=self.camping_plot.is_shaded,
            grey_water_discharge=self.camping_plot.grey_water_discharge,
            description=self.camping_plot.description,
        )

        assert camping_plot.position == self.camping_plot.position
        assert camping_plot.max_number_of_people == self.camping_plot.max_number_of_people
        assert camping_plot.width == self.camping_plot.width
        assert camping_plot.length == self.camping_plot.length
        assert camping_plot.camping_section == self.camping_section
        assert camping_plot.water_connection == self.camping_plot.water_connection
        assert camping_plot.electricity_connection == self.camping_plot.electricity_connection
        assert camping_plot.is_shaded == self.camping_plot.is_shaded
        assert camping_plot.grey_water_discharge == self.camping_plot.grey_water_discharge
        assert camping_plot.description == self.camping_plot.description

    def test_create_camping_plot_without_optional_fields(self):
        camping_plot = CampingPlotCommand.create(
            position=self.camping_plot.position,
            max_number_of_people=self.camping_plot.max_number_of_people,
            width=self.camping_plot.width,
            length=self.camping_plot.length,
            camping_section_name=self.camping_section.name,
        )

        assert camping_plot.position == self.camping_plot.position
        assert camping_plot.max_number_of_people == self.camping_plot.max_number_of_people
        assert camping_plot.width == self.camping_plot.width
        assert camping_plot.length == self.camping_plot.length
        assert camping_plot.camping_section == self.camping_section
        assert camping_plot.water_connection is False
        assert camping_plot.electricity_connection is False
        assert camping_plot.is_shaded is False
        assert camping_plot.grey_water_discharge is False
        assert camping_plot.description is None

    def test_create_camping_plot_without_existing_camping_section(self):
        camping_section_name = 'not_existing_camping_section'

        with self.assertRaises(CampingSectionNotExistsError):
            CampingPlotCommand.create(
                position=self.camping_plot.position,
                max_number_of_people=self.camping_plot.max_number_of_people,
                width=self.camping_plot.width,
                length=self.camping_plot.length,
                camping_section_name=camping_section_name,
                water_connection=self.camping_plot.water_connection,
                electricity_connection=self.camping_plot.electricity_connection,
                is_shaded=self.camping_plot.is_shaded,
                grey_water_discharge=self.camping_plot.grey_water_discharge,
                description=self.camping_plot.description,
            )
