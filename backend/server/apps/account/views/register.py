from rest_framework.generics import CreateAPIView
from rest_framework.permissions import AllowAny

from server.apps.account.models import Account
from server.apps.account.serializers import AccountRegisterSerializer


class AccountRegisterView(CreateAPIView):
    permission_classes = [AllowAny]
    serializer_class = AccountRegisterSerializer
    queryset = Account.objects.all()
