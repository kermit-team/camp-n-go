import uuid

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.account.views.details import AccountDetailsView
from server.apps.car.models import Car


class AccountDetailsViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = AccountDetailsView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)
        self.cars = baker.make(_model=Car, _quantity=2)
        for car in self.cars:
            car.drivers.add(self.account)

    def test_request(self):
        parameters = {
            'identifier': self.account.identifier,
        }
        url = reverse('details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = AccountDetailsView.serializer_class(
            instance=self.account,
            context={'request': req},
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_request_without_existing_account(self):
        parameters = {
            'identifier': uuid.uuid4(),
        }
        url = reverse('details', kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
