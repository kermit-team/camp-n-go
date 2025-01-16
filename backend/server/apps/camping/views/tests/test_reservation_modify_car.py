from unittest import mock

from django.urls import reverse
from model_bakery import baker
from rest_framework import status
from rest_framework.test import APIRequestFactory, APITestCase, force_authenticate

from server.apps.account.models import Account, AccountProfile
from server.apps.camping.models import Reservation
from server.apps.camping.views import ReservationModifyCarView
from server.apps.car.models import Car
from server.business_logic.camping import ReservationModifyCarBL


class ReservationModifyCarViewTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.factory = APIRequestFactory()
        cls.view = ReservationModifyCarView

    def setUp(self):
        self.account = baker.make(_model=Account, is_superuser=True, _fill_optional=True)
        self.account_profile = baker.make(_model=AccountProfile, account=self.account, _fill_optional=True)

        self.reservation = baker.make(_model=Reservation, user=self.account, _fill_optional=True)
        self.new_car = baker.make(_model=Car, _fill_optional=True)
        self.new_car.drivers.add(self.account)

    @mock.patch.object(ReservationModifyCarBL, 'process')
    def test_request(self, modify_reservation_car_mock):
        modify_reservation_car_mock.return_value = self.reservation
        request_data = {
            'car': self.new_car.id,
        }
        parameters = {
            'pk': self.reservation.id,
        }
        url = reverse('reservation_modify_car', kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = self.view.serializer_class(
            instance=modify_reservation_car_mock.return_value,
            context={'request': req},
        ).data

        modify_reservation_car_mock.assert_called_once_with(
            reservation=self.reservation,
            car=self.new_car,
        )
        assert res.status_code == status.HTTP_200_OK
        assert res.data == expected_data

    @mock.patch.object(ReservationModifyCarBL, 'process')
    def test_request_without_existing_reservation(self, modify_reservation_car_mock):
        request_data = {
            'car': self.new_car.id,
        }
        parameters = {
            'pk': 0,
        }
        url = reverse('reservation_modify_car', kwargs=parameters)

        req = self.factory.put(url, data=request_data)
        force_authenticate(req, user=self.account)
        res = self.view.as_view()(req, **parameters)

        expected_data = {'message': 'error'}

        modify_reservation_car_mock.assert_not_called()
        assert res.status_code == status.HTTP_404_NOT_FOUND
        assert res.data == expected_data
