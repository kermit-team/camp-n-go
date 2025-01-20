from django.urls import path

from server.apps.account.views.admin import (
    AdminAccountCreateView,
    AdminAccountListView,
    AdminAccountModifyView,
    AdminGroupListView,
)

urlpatterns = [
    path(
        '',
        AdminAccountListView.as_view(),
        name='admin_account_list',
    ),
    path(
        'create/',
        AdminAccountCreateView.as_view(),
        name='admin_account_create',
    ),
    path(
        '<str:identifier>/modify/',
        AdminAccountModifyView.as_view(),
        name='admin_account_modify',
    ),
    path(
        'groups/',
        AdminGroupListView.as_view(),
        name='admin_group_list',
    ),
]
