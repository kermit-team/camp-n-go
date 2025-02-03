from django.core.handlers.wsgi import WSGIRequest
from rest_framework.permissions import BasePermission
from rest_framework.views import View

from server.apps.account.models import Account


class AccountObjectPermissions(BasePermission):
    def has_object_permission(self, request: WSGIRequest, view: View, obj: Account) -> bool:
        return request.user == obj
