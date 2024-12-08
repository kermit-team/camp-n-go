from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from server.apps.account.views import (
    AccountDetailsView,
    AccountEmailVerificationResendView,
    AccountEmailVerificationView,
    AccountPasswordResetConfirmView,
    AccountPasswordResetView,
    AccountRegisterView,
)

urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('register/', AccountRegisterView.as_view(), name='register'),
    path(
        'email-verification/<str:uidb64>/<str:token>/',
        AccountEmailVerificationView.as_view(),
        name='email_verification',
    ),
    path(
        'email-verification/resend/',
        AccountEmailVerificationResendView.as_view(),
        name='email_verification_resend',
    ),
    path(
        'password-reset/',
        AccountPasswordResetView.as_view(),
        name='password_reset',
    ),
    path(
        'password-reset/confirm/<str:uidb64>/<str:token>/',
        AccountPasswordResetConfirmView.as_view(),
        name='password_reset_confirm',
    ),
    path(
        'details/<str:identifier>/',
        AccountDetailsView.as_view(),
        name='details',
    ),
]
