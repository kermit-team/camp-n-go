from typing import Callable, Optional

from django.conf import settings
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from django.core.handlers.wsgi import WSGIRequest
from model_bakery import baker
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import force_authenticate

from server.apps.account.models import Account
from server.business_logic.account import LoadGroupsBL, LoadPermissionsBL
from server.utils.tests.baker_generators import generate_password


class AccountViewPermissionsTestMixin:
    success_status_codes = (status.HTTP_200_OK, status.HTTP_201_CREATED, status.HTTP_204_NO_CONTENT)
    unauthorized_status_codes = (status.HTTP_401_UNAUTHORIZED, status.HTTP_403_FORBIDDEN)

    def _create_accounts_with_groups_and_permissions(self) -> None:
        Account.objects.all().delete()

        LoadPermissionsBL.process()
        LoadGroupsBL.process()

        owner_group = Group.objects.get(name=settings.OWNER)
        employee_group = Group.objects.get(name=settings.EMPLOYEE)
        client_group = Group.objects.get(name=settings.CLIENT)

        self.accounts_password = generate_password()

        self._account = baker.make(_model=Account, password=make_password(self.accounts_password))

        self._owner = baker.make(_model=Account, password=make_password(self.accounts_password))
        self._owner.groups.add(owner_group)

        self._employee = baker.make(_model=Account, password=make_password(self.accounts_password))
        self._employee.groups.add(employee_group)

        self._client = baker.make(_model=Account, password=make_password(self.accounts_password))
        self._client.groups.add(client_group)

        self._superuser = baker.make(
            _model=Account,
            password=make_password(self.accounts_password),
            is_superuser=True,
        )

    def _test_list_permissions(self, data: Optional[dict] = None) -> None:
        url = reverse(self.viewname)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.get,
            data=data,
        )

    def _test_create_permissions(self, data: dict) -> None:
        url = reverse(self.viewname)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.post,
            data=data,
        )

    def _test_retrieve_permissions(self, parameters: dict) -> None:
        url = reverse(self.viewname, kwargs=parameters)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.get,
            parameters=parameters,
        )

    def _test_update_permissions(self, parameters: dict, data: dict) -> None:
        url = reverse(self.viewname, kwargs=parameters)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.put,
            parameters=parameters,
            data=data,
        )

    def _test_partial_update_permissions(self, parameters: dict, data: dict) -> None:
        url = reverse(self.viewname, kwargs=parameters)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.patch,
            parameters=parameters,
            data=data,
        )

    def _test_destroy_permissions(self, parameters: dict) -> None:
        url = reverse(self.viewname, kwargs=parameters)
        self._test_view_permissions(
            url=url,
            request_factory_handler=self.factory.delete,
            parameters=parameters,
        )

    def _test_custom_view_permissions(
        self,
        request_factory_handler: Callable,
        parameters: Optional[dict] = None,
        data: Optional[dict] = None,
    ) -> None:
        if parameters is None:
            parameters = {}

        if data is None:
            data = {}

        url = reverse(self.viewname, kwargs=parameters)
        self._test_view_permissions(
            url=url,
            request_factory_handler=request_factory_handler,
            parameters=parameters,
            data=data,
        )

    def _test_view_permissions(
        self,
        url: str,
        request_factory_handler: Callable,
        parameters: Optional[dict] = None,
        data: Optional[dict] = None,
    ) -> None:
        accounts_with_view_permissions = (
            (None, self.view_permissions.anon),
            (self._account, self.view_permissions.account),
            (self._owner, self.view_permissions.owner),
            (self._employee, self.view_permissions.employee),
            (self._client, self.view_permissions.client),
            (self._superuser, self.view_permissions.superuser),
        )

        for account, has_permissions in accounts_with_view_permissions:
            request = request_factory_handler(url, data=data)
            self._test_account_view_permissions(
                request=request,
                has_permissions=has_permissions,
                account=account,
                parameters=parameters,
            )

    def _test_account_view_permissions(
        self,
        request: WSGIRequest,
        has_permissions: bool,
        account: Optional[Account] = None,
        parameters: Optional[dict] = None,
    ) -> None:
        if parameters is None:
            parameters = {}

        force_authenticate(request, user=account)
        res = self.view.as_view()(request, **parameters)
        expected_status_codes = self.success_status_codes if has_permissions else self.unauthorized_status_codes

        assert res.status_code in expected_status_codes
