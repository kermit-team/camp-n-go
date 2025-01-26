from django.conf import settings

from server.apps.account.models import AccountProfile


class AccountProfileCommand:
    @classmethod
    def anonymize(cls, account_profile: AccountProfile) -> AccountProfile:
        account_profile.first_name = settings.ANONYMIZED_FIRST_NAME
        account_profile.last_name = settings.ANONYMIZED_LAST_NAME
        account_profile.phone_number = None
        account_profile.avatar = None
        account_profile.id_card = None

        account_profile.save()

        return account_profile
