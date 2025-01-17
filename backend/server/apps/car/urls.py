from django.urls import path

from server.apps.car.views import CarAddView, CarRemoveDriverView

urlpatterns = [
    path(
        'add/',
        CarAddView.as_view(),
        name='car_add',
    ),
    path(
        '<int:pk>/remove-driver/',
        CarRemoveDriverView.as_view(),
        name='car_remove_driver',
    ),
]
