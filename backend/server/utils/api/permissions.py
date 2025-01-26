from django.core.handlers.wsgi import WSGIRequest
from rest_framework.permissions import BasePermission, DjangoModelPermissions
from rest_framework.views import View

from server.settings.components.permissions import EMPLOYEE, OWNER


class DjangoModelPermissionsWithGetPermissions(DjangoModelPermissions):
    perms_map = {
        'GET': ['%(app_label)s.view_%(model_name)s'],
        'OPTIONS': [],
        'HEAD': [],
        'POST': ['%(app_label)s.add_%(model_name)s'],
        'PUT': ['%(app_label)s.change_%(model_name)s'],
        'PATCH': ['%(app_label)s.change_%(model_name)s'],
        'DELETE': ['%(app_label)s.delete_%(model_name)s'],
    }


class AdminPermissions(BasePermission):
    def has_permission(self, request: WSGIRequest, view: View) -> bool:
        user_has_administration_group = request.user.groups.filter(name=OWNER).exists()
        return request.user.is_superuser or user_has_administration_group


class StaffPermissions(BasePermission):
    def has_permission(self, request: WSGIRequest, view: View) -> bool:
        user_has_staff_group = request.user.groups.filter(name__in=[OWNER, EMPLOYEE]).exists()
        return request.user.is_superuser or user_has_staff_group
