from django.urls import path

from server.apps.camping.views import (
    CampingPlotAvailabilityListView,
    ContactFormSendView,
    ReservationCancelView,
    ReservationCreateView,
    ReservationDetailsView,
    ReservationListView,
    ReservationModifyCarView,
    StripePaymentWebhookView,
)

urlpatterns = [
    path(
        'plots/available/',
        CampingPlotAvailabilityListView.as_view(),
        name='camping_plot_availability_list',
    ),
    path(
        'reservations/',
        ReservationListView.as_view(),
        name='reservation_list',
    ),
    path(
        'reservations/create/',
        ReservationCreateView.as_view(),
        name='reservation_create',
    ),
    path(
        'reservations/<int:pk>/details/',
        ReservationDetailsView.as_view(),
        name='reservation_details',
    ),
    path(
        'reservations/<int:pk>/modify/car/',
        ReservationModifyCarView.as_view(),
        name='reservation_modify_car',
    ),
    path(
        'reservations/<int:pk>/cancel/',
        ReservationCancelView.as_view(),
        name='reservation_cancel',
    ),
    path(
        'payments/webhook/',
        StripePaymentWebhookView.as_view(),
        name='payment_webhook',
    ),
    path(
        'contact-form/send/',
        ContactFormSendView.as_view(),
        name='contact_form_send',
    ),
]
