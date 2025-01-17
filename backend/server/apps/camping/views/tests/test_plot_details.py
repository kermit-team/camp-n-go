from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import CampingPlot, CampingSection
from server.apps.camping.views import CampingPlotDetailsView


class CampingPlotDetailsViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = CampingPlotDetailsView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.camping_section = baker.make(_model=CampingSection, _fill_optional=True)
        self.camping_plot = baker.make(_model=CampingPlot, camping_section=self.camping_section, _fill_optional=True)

    def test_request(self):
        parameters = {
            'pk': self.camping_plot.id,
        }
        url = reverse('camping_plot_details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=self.camping_plot,
            context={'request': req},
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_request_without_existing_camping_plot(self):
        parameters = {
            'pk': 0,
        }
        url = reverse('camping_plot_details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
