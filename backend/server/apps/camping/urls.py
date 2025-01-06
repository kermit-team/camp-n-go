from django.urls import path

from server.apps.camping.views import (
    CampingPlotDetailsView,
    CampingPlotListView,
    CampingSectionDetailsView,
    CampingSectionModifyView,
)

urlpatterns = [
    path(
        '/',
        CampingPlotListView.as_view(),
        name='camping_plot_list',
    ),
    path(
        '<str:camping_section__name>/<str:position>/',
        CampingPlotDetailsView.as_view(),
        name='camping_plot_details',
    ),
    path(
        '<str:name>/',
        CampingSectionDetailsView.as_view(),
        name='camping_section_details',
    ),
    path(
        '<str:name>/modify/',
        CampingSectionModifyView.as_view(),
        name='camping_section_modify',
    ),
]
