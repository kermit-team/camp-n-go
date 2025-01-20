import uuid

from django.db.models import QuerySet

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
