from django.utils.translation import gettext_lazy as _

OWNER = _('Owner')
EMPLOYEE = _('Employee')
CLIENT = _('Client')

# Custom permission names
PASSWORD_CHANGE = 'password_change'  # noqa: S105

ADD_ACCOUNT = 'add_account'
CHANGE_ACCOUNT = 'change_account'
DELETE_ACCOUNT = 'delete_account'
VIEW_ACCOUNT = 'view_account'
ACCOUNT_FULL = (
    VIEW_ACCOUNT,
    ADD_ACCOUNT,
    CHANGE_ACCOUNT,
    DELETE_ACCOUNT,
    PASSWORD_CHANGE,
)

PERMISSIONS = (
    {
        'NAME': 'Can change password',
        'CODENAME': PASSWORD_CHANGE,
        'CONTENT_TYPE_MODEL': 'account',
        'CONTENT_TYPE_APP_LABEL': 'account',
    },
)

GROUPS = (
    {
        'NAME': OWNER,
        'PERMISSIONS': (
            VIEW_ACCOUNT,
            PASSWORD_CHANGE,
        ),
    },
    {
        'NAME': EMPLOYEE,
        'PERMISSIONS': (
            VIEW_ACCOUNT,
            PASSWORD_CHANGE,
        ),
    },
    {
        'NAME': CLIENT,
        'PERMISSIONS': (
            VIEW_ACCOUNT,
            PASSWORD_CHANGE,
        ),
    },
)
