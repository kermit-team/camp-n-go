from django.test import TestCase
from model_bakery import baker

from server.apps.camping.models import CampingSection
from server.datastore.queries.camping import CampingSectionQuery


class CampingSectionQueryTestCase(TestCase):
    def setUp(self):
        self.camping_section = baker.make(_model=CampingSection)

    def test_get_by_name(self):
        name = self.camping_section.name

        camping_section = CampingSectionQuery.get_by_name(name=name)

        assert camping_section

    def test_get_by_name_without_existing_camping_section(self):
        name = 'not_existing_name'

        with self.assertRaises(CampingSection.DoesNotExist):
            CampingSectionQuery.get_by_name(name=name)

    def test_get_queryset(self):
        CampingSection.objects.all().delete()
        camping_sections = baker.make(_model=CampingSection, _quantity=3)

        queryset = CampingSectionQuery.get_queryset()

        self.assertCountEqual(queryset, camping_sections)
