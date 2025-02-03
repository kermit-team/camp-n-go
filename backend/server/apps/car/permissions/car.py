from django.core.handlers.wsgi import WSGIRequest
from rest_framework.permissions import BasePermission
from rest_framework.views import View

from server.apps.car.models import Car


class CarObjectPermissions(BasePermission):
    def has_object_permission(self, request: WSGIRequest, view: View, obj: Car) -> bool:
        return obj.drivers.filter(pk=request.user.pk).exists()
