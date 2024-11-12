from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from server.apps.account.views import AccountEmailVerificationView, AccountRegisterView

urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='account_token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='account_token_refresh'),
    path('register/', AccountRegisterView.as_view(), name='account_register'),
    path(
        'email-verification/<str:uidb64>/<str:token>',
        AccountEmailVerificationView.as_view(),
        name='account_email_verification',
    ),
]
