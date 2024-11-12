import uuid

from server.apps.account.models import Account


class AccountQuery:
    @classmethod
    def get_by_identifier(cls, identifier: uuid.UUID) -> Account:
        return Account.objects.get(identifier=identifier)
