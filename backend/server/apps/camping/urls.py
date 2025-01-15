from django.urls import path

from server.apps.camping.views import (
    CampingPlotAvailabilityListView,
    CampingPlotDetailsView,
    CampingSectionDetailsView,
    CampingSectionModifyView,
    ReservationCreateView,
    StripePaymentWebhookView,
)

urlpatterns = [
    path(
        'plots/available/',
        CampingPlotAvailabilityListView.as_view(),
        name='camping_plot_availability_list',
    ),
    path(
        'plots/<int:pk>/',
        CampingPlotDetailsView.as_view(),
        name='camping_plot_details',
    ),
    path(
        'sections/<int:pk>/',
        CampingSectionDetailsView.as_view(),
        name='camping_section_details',
    ),
    path(
        'sections/<int:pk>/modify/',
        CampingSectionModifyView.as_view(),
        name='camping_section_modify',
    ),
    path(
        'reservations/create/',
        ReservationCreateView.as_view(),
        name='reservation_create',
    ),
    path(
        'payments/webhook/',
        StripePaymentWebhookView.as_view(),
        name='payment_webhook',
    ),
]
