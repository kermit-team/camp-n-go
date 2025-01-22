from django.urls import path

from server.apps.camping.views.admin import AdminCampingSectionModifyView

urlpatterns = [
    path(
        'sections/<int:pk>/modify/',
        AdminCampingSectionModifyView.as_view(),
        name='admin_camping_section_modify',
    ),
]
