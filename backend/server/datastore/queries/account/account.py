import uuid
from typing import Optional

from django.db.models import Q, QuerySet

from server.apps.account.models import Account


class AccountQuery:

    @classmethod
    def get_by_identifier(cls, identifier: uuid.UUID) -> Account:
        return Account.objects.get(identifier=identifier)

    @classmethod
    def get_by_email(cls, email: str) -> Account:
        return Account.objects.get(email=email)

    @classmethod
    def get_queryset_for_account(cls, account: Account) -> QuerySet:
        queryset = Account.objects.order_by('-id')

        if not account.is_superuser:
            queryset = queryset.exclude(is_superuser=True)

        return queryset

    @classmethod
    def get_with_matching_personal_data(cls, personal_data: str, queryset: Optional[QuerySet] = None) -> QuerySet:
        if not queryset:
            queryset = Account.objects.order_by('-id')

        return queryset.filter(
            Q(email__icontains=personal_data) |
            Q(profile__first_name__icontains=personal_data) |
            Q(profile__last_name__icontains=personal_data),
        )
