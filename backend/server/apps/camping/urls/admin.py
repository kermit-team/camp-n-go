from django.urls import path

from server.apps.camping.views.admin import (
    AdminCampingPlotDetailsView,
    AdminCampingSectionDetailsView,
    AdminCampingSectionListView,
    AdminCampingSectionModifyView,
    AdminReservationListView,
)

urlpatterns = [
    path(
        'sections/<int:pk>/',
        AdminCampingSectionDetailsView.as_view(),
        name='admin_camping_section_details',
    ),
    path(
        'sections/',
        AdminCampingSectionListView.as_view(),
        name='admin_camping_section_list',
    ),
    path(
        'sections/<int:pk>/modify/',
        AdminCampingSectionModifyView.as_view(),
        name='admin_camping_section_modify',
    ),
    path(
        'plots/<int:pk>/',
        AdminCampingPlotDetailsView.as_view(),
        name='admin_camping_plot_details',
    ),
    path(
        'reservations/',
        AdminReservationListView.as_view(),
        name='admin_reservation_list',
    ),
]
