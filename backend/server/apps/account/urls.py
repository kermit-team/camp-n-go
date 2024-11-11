from django.urls import path

from server.apps.account.views import AccountRegisterView

urlpatterns = [
    path('register/', AccountRegisterView.as_view(), name='account-register'),
]
