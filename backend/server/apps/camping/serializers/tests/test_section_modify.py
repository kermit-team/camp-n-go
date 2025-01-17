from unittest import mock

from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingSection
from server.apps.camping.serializers import CampingSectionModifySerializer
from server.datastore.commands.camping import CampingSectionCommand


class CampingSectionModifySerializerTestCase(TestCase):

    def setUp(self):
        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.new_camping_section_data = baker.prepare(_model=CampingSection, _fill_optional=True)

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_update(self, modify_camping_section_mock):
        serializer = CampingSectionModifySerializer(
            instance=self.camping_section,
            data={
                'base_price': self.new_camping_section_data.base_price,
                'price_per_adult': self.new_camping_section_data.price_per_adult,
                'price_per_child': self.new_camping_section_data.price_per_child,
            },
        )

        assert serializer.is_valid()
        serializer.save()

        modify_camping_section_mock.assert_called_once_with(
            camping_section=self.camping_section,
            base_price=self.new_camping_section_data.base_price,
            price_per_adult=self.new_camping_section_data.price_per_adult,
            price_per_child=self.new_camping_section_data.price_per_child,
        )

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_update_without_required_fields(self, modify_camping_section_mock):
        serializer = CampingSectionModifySerializer(
            instance=self.camping_section,
            data={
                'base_price': self.new_camping_section_data.base_price,
            },
        )

        assert not serializer.is_valid()
        modify_camping_section_mock.assert_not_called()

    @mock.patch.object(CampingSectionCommand, 'modify')
    def test_partial_update(self, modify_camping_section_mock):
        serializer = CampingSectionModifySerializer(
            instance=self.camping_section,
            data={
                'price_per_adult': self.new_camping_section_data.price_per_adult,
                'price_per_child': self.new_camping_section_data.price_per_child,
            },
            partial=True,
        )

        assert serializer.is_valid()
        serializer.save()

        modify_camping_section_mock.assert_called_once_with(
            camping_section=self.camping_section,
            price_per_adult=self.new_camping_section_data.price_per_adult,
            price_per_child=self.new_camping_section_data.price_per_child,
        )
