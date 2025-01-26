from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationDetailsView
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class ReservationDetailsViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationDetailsView
        cls.viewname = 'reservation_details'
        cls.view_permissions = AccountViewPermissions(
            owner=True,
            employee=True,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.reservation = baker.make(_model=Reservation, _fill_optional=True)

    def test_request(self):
        parameters = {'pk': self.reservation.id}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=self.reservation,
            context={'request': req},
        ).data

        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    def test_request_without_existing_reservation(self):
        parameters = {'pk': 0}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.get(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    def test_permissions(self):
        Reservation.objects.all().delete()
        self._create_accounts_with_groups_and_permissions()

        reservation = baker.make(_model=Reservation, _fill_optional=True)
        parameters = {'pk': reservation.id}

        self._test_retrieve_permissions(parameters=parameters)

    def test_permissions_as_object_relation(self):
        Reservation.objects.all().delete()
        self._create_accounts_with_groups_and_permissions()

        reservation = baker.make(_model=Reservation, _fill_optional=True)
        parameters = {'pk': reservation.id}

        accounts_with_view_permissions = (
            (None, False),
            (self._account, False),
            (self._owner, True),
            (self._employee, True),
            (self._client, True),
            (self._superuser, True),
        )

        for account, has_permissions in accounts_with_view_permissions:
            if account:
                reservation.user = account
                reservation.save()

            url = reverse(self.viewname, kwargs=parameters)

            request = self.factory.get(url)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
