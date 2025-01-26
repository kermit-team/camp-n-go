from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.messages.reservation import ReservationMessagesEnum
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationCancelView
from server.business_logic.camping import ReservationCancelBL
from server.utils.tests.account_view_permissions import AccountViewPermissions
from server.utils.tests.account_view_permissions_mixin import AccountViewPermissionsTestMixin


class ReservationCancelViewTestCase(AccountViewPermissionsTestMixin, APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationCancelView
        cls.viewname = 'reservation_cancel'
        cls.view_permissions = AccountViewPermissions(
            superuser=False,
        )

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_request(self, cancel_reservation_mock):
        parameters = {'pk': self.reservation.id}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {
            'message': ReservationMessagesEnum.CANCELLATION_SUCCESS.value,
        }

        cancel_reservation_mock.assert_called_once_with(reservation=self.reservation)
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_request_without_existing_reservation(self, cancel_reservation_mock):
        parameters = {'pk': 0}
        url = reverse(self.viewname, kwargs=parameters)

        req = self.factory.patch(url)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        cancel_reservation_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_permissions(self, cancel_reservation_mock):
        Reservation.objects.all().delete()
        self._create_accounts_with_groups_and_permissions()

        reservation = baker.make(_model=Reservation, _fill_optional=True)
        parameters = {'pk': reservation.id}

        self._test_custom_view_permissions(request_factory_handler=self.factory.patch, parameters=parameters)

    @mock.patch.object(ReservationCancelBL, 'process')
    def test_permissions_as_object_relation(self, cancel_reservation_mock):
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

            request = self.factory.patch(url)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )
