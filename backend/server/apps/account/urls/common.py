from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from server.apps.account.views import (
    AccountAnonymizeView,
    AccountDetailsView,
    AccountEmailVerificationResendView,
    AccountEmailVerificationView,
    AccountModifyView,
    AccountPasswordResetConfirmView,
    AccountPasswordResetView,
    AccountRegisterView,
)

urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='account_token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='account_token_refresh'),
    path('register/', AccountRegisterView.as_view(), name='account_register'),
    path(
        'email-verification/<str:uidb64>/<str:token>/',
        AccountEmailVerificationView.as_view(),
        name='account_email_verification',
    ),
    path(
        'email-verification/resend/',
        AccountEmailVerificationResendView.as_view(),
        name='account_email_verification_resend',
    ),
    path(
        'password-reset/',
        AccountPasswordResetView.as_view(),
        name='account_password_reset',
    ),
    path(
        'password-reset/confirm/<str:uidb64>/<str:token>/',
        AccountPasswordResetConfirmView.as_view(),
        name='account_password_reset_confirm',
    ),
    path(
        '<str:identifier>/',
        AccountDetailsView.as_view(),
        name='account_details',
    ),
    path(
        '<str:identifier>/modify/',
        AccountModifyView.as_view(),
        name='account_modify',
    ),
    path(
        '<str:identifier>/anonymize/',
        AccountAnonymizeView.as_view(),
        name='account_anonymize',
    ),
]
