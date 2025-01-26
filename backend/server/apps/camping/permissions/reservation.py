from django.core.handlers.wsgi import WSGIRequest
from rest_framework.permissions import BasePermission
from rest_framework.views import View

from server.apps.camping.models import Reservation


class ReservationObjectPermissions(BasePermission):
    def has_object_permission(self, request: WSGIRequest, view: View, obj: Reservation):
        return request.user == obj.user
