from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingSection
from server.datastore.commands.camping import CampingSectionCommand


class CampingSectionCommandTestCase(TestCase):

    def setUp(self):
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)

    def test_create_camping_section(self):
        new_camping_section_data = baker.prepare(_model=CampingSection, _fill_optional=True)

        camping_section = CampingSectionCommand.create(
            name=new_camping_section_data.name,
            base_price=new_camping_section_data.base_price,
            price_per_adult=new_camping_section_data.price_per_child,
            price_per_child=new_camping_section_data.price_per_child,
        )

        assert camping_section is not None

    def test_modify_camping_section(self):
        new_camping_section_data = baker.prepare(_model=CampingSection, _fill_optional=True)

        camping_section = CampingSectionCommand.modify(
            camping_section=self.camping_section,
            base_price=new_camping_section_data.base_price,
            price_per_adult=new_camping_section_data.price_per_adult,
            price_per_child=new_camping_section_data.price_per_child,
        )

        assert camping_section.base_price == new_camping_section_data.base_price
        assert camping_section.price_per_adult == new_camping_section_data.price_per_adult
        assert camping_section.price_per_child == new_camping_section_data.price_per_child

    def test_modify_camping_section_without_optional_fields(self):
        camping_section = CampingSectionCommand.modify(camping_section=self.camping_section)

        assert camping_section.base_price == self.camping_section.base_price
        assert camping_section.price_per_adult == self.camping_section.price_per_adult
        assert camping_section.price_per_child == self.camping_section.price_per_child
