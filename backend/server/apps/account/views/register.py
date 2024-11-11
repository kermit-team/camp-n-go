from rest_framework.generics import CreateAPIView

from server.apps.account.models import Account
from server.apps.account.serializers import AccountRegisterSerializer


class AccountRegisterView(CreateAPIView):
    serializer_class = AccountRegisterSerializer
    queryset = Account.objects.all()
