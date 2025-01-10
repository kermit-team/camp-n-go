from django.urls import path

from server.apps.camping.views import (
    CampingPlotAvailabilityListView,
    CampingPlotDetailsView,
    CampingSectionDetailsView,
    CampingSectionModifyView,
)

urlpatterns = [
    path(
        'plots/available/',
        CampingPlotAvailabilityListView.as_view(),
        name='camping_plot_availability_list',
    ),
    path(
        'sections/<str:camping_section__name>/plots/<str:position>/',
        CampingPlotDetailsView.as_view(),
        name='camping_plot_details',
    ),
    path(
        'sections/<str:name>/',
        CampingSectionDetailsView.as_view(),
        name='camping_section_details',
    ),
    path(
        'sections/<str:name>/modify/',
        CampingSectionModifyView.as_view(),
        name='camping_section_modify',
    ),
]
