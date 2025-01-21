from unittest import mock

from django.contrib.auth.models import Group
from django.test import TestCase
from model_bakery import baker

from server.apps.account.filters import AccountListFilter
from server.apps.account.models import Account
from server.datastore.queries.account import AccountQuery


class AccountListFilterTestCase(TestCase):
    def setUp(self):
        self.accounts = baker.make(_model=Account, _quantity=3)
        self.groups = baker.make(_model=Group, _quantity=2)
        self.accounts[0].groups.add(self.groups[0])
        self.accounts[1].groups.add(self.groups[1])

    @mock.patch.object(AccountQuery, 'get_with_matching_personal_data')
    def test_filter_queryset(self, get_with_matching_personal_data_mock):
        queryset = Account.objects.all()
        expected_accounts = queryset.filter(groups__id=self.groups[0].id)
        get_with_matching_personal_data_mock.return_value = expected_accounts
        personal_data = 'abc'

        account_filter = AccountListFilter(
            data={
                'personal_data': personal_data,
                'group': self.groups[0].id,
            },
            queryset=queryset,
        )
        assert account_filter.is_valid()

        results = account_filter.filter_queryset(queryset=queryset)

        get_with_matching_personal_data_mock.assert_called_once()
        assert get_with_matching_personal_data_mock.call_args_list[0].kwargs['personal_data'] == personal_data
        self.assertCountEqual(
            get_with_matching_personal_data_mock.call_args_list[0].kwargs['queryset'],
            expected_accounts,
        )
        self.assertCountEqual(results, expected_accounts)

    @mock.patch.object(AccountQuery, 'get_with_matching_personal_data')
    def test_filter_queryset_without_optional_filters(self, get_with_matching_personal_data_mock):
        queryset = Account.objects.all()
        get_with_matching_personal_data_mock.return_value = queryset

        account_filter = AccountListFilter(
            data={},
            queryset=queryset,
        )
        assert account_filter.is_valid()

        results = account_filter.filter_queryset(queryset=queryset)

        get_with_matching_personal_data_mock.assert_not_called()
        self.assertCountEqual(results, self.accounts)
