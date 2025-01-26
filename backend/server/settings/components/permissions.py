from django.utils.translation import gettext_lazy as _

OWNER = _('Owner')
EMPLOYEE = _('Employee')
CLIENT = _('Client')

# Custom permissions
PERMISSIONS = ()

ADD_ACCOUNT = 'add_account'
CHANGE_ACCOUNT = 'change_account'
DELETE_ACCOUNT = 'delete_account'
VIEW_ACCOUNT = 'view_account'
ACCOUNT_FULL = (
    ADD_ACCOUNT,
    CHANGE_ACCOUNT,
    DELETE_ACCOUNT,
    VIEW_ACCOUNT,
)

ADD_ACCOUNT_PROFILE = 'add_accountprofile'
CHANGE_ACCOUNT_PROFILE = 'change_accountprofile'
DELETE_ACCOUNT_PROFILE = 'delete_accountprofile'
VIEW_ACCOUNT_PROFILE = 'view_accountprofile'
ACCOUNT_PROFILE_FULL = (
    ADD_ACCOUNT_PROFILE,
    CHANGE_ACCOUNT_PROFILE,
    DELETE_ACCOUNT_PROFILE,
    VIEW_ACCOUNT_PROFILE,
)

ADD_GROUP = 'add_group'
CHANGE_GROUP = 'change_group'
DELETE_GROUP = 'delete_group'
VIEW_GROUP = 'view_group'
GROUP_FULL = (
    ADD_GROUP,
    CHANGE_GROUP,
    DELETE_GROUP,
    VIEW_GROUP,
)

ADD_CAMPING_SECTION = 'add_campingsection'
CHANGE_CAMPING_SECTION = 'change_campingsection'
DELETE_CAMPING_SECTION = 'delete_campingsection'
VIEW_CAMPING_SECTION = 'view_campingsection'
CAMPING_SECTION_FULL = (
    ADD_CAMPING_SECTION,
    CHANGE_CAMPING_SECTION,
    DELETE_CAMPING_SECTION,
    VIEW_CAMPING_SECTION,
)

ADD_CAMPING_PLOT = 'add_campingplot'
CHANGE_CAMPING_PLOT = 'change_campingplot'
DELETE_CAMPING_PLOT = 'delete_campingplot'
VIEW_CAMPING_PLOT = 'view_campingplot'
CAMPING_PLOT_FULL = (
    ADD_CAMPING_PLOT,
    CHANGE_CAMPING_PLOT,
    DELETE_CAMPING_PLOT,
    VIEW_CAMPING_PLOT,
)

ADD_PAYMENT = 'add_payment'
CHANGE_PAYMENT = 'change_payment'
DELETE_PAYMENT = 'delete_payment'
VIEW_PAYMENT = 'view_payment'
PAYMENT_FULL = (
    ADD_PAYMENT,
    CHANGE_PAYMENT,
    DELETE_PAYMENT,
    VIEW_PAYMENT,
)

ADD_RESERVATION = 'add_reservation'
CHANGE_RESERVATION = 'change_reservation'
DELETE_RESERVATION = 'delete_reservation'
VIEW_RESERVATION = 'view_reservation'
RESERVATION_FULL = (
    ADD_RESERVATION,
    CHANGE_RESERVATION,
    DELETE_RESERVATION,
    VIEW_RESERVATION,
)

ADD_CAR = 'add_car'
CHANGE_CAR = 'change_car'
DELETE_CAR = 'delete_car'
VIEW_CAR = 'view_car'
CAR_FULL = (
    ADD_CAR,
    CHANGE_CAR,
    DELETE_CAR,
    VIEW_CAR,
)

GROUPS = (
    {
        'NAME': OWNER,
        'PERMISSIONS': (
            ADD_ACCOUNT,
            CHANGE_ACCOUNT,
            VIEW_ACCOUNT,
            VIEW_GROUP,
            ADD_CAMPING_SECTION,
            CHANGE_CAMPING_SECTION,
            VIEW_CAMPING_SECTION,
            ADD_CAMPING_PLOT,
            CHANGE_CAMPING_PLOT,
            VIEW_CAMPING_PLOT,
            ADD_RESERVATION,
            CHANGE_RESERVATION,
            VIEW_RESERVATION,
            ADD_CAR,
            DELETE_CAR,
            VIEW_CAR,
        ),
    },
    {
        'NAME': EMPLOYEE,
        'PERMISSIONS': (
            ADD_ACCOUNT,
            CHANGE_ACCOUNT,
            VIEW_ACCOUNT,
            VIEW_GROUP,
            ADD_CAMPING_SECTION,
            CHANGE_CAMPING_SECTION,
            VIEW_CAMPING_SECTION,
            ADD_CAMPING_PLOT,
            CHANGE_CAMPING_PLOT,
            VIEW_CAMPING_PLOT,
            ADD_RESERVATION,
            CHANGE_RESERVATION,
            VIEW_RESERVATION,
            ADD_CAR,
            DELETE_CAR,
            VIEW_CAR,
        ),
    },
    {
        'NAME': CLIENT,
        'PERMISSIONS': (
            ADD_ACCOUNT,
            CHANGE_ACCOUNT,
            VIEW_ACCOUNT,
            ADD_RESERVATION,
            CHANGE_RESERVATION,
            VIEW_RESERVATION,
            ADD_CAR,
            DELETE_CAR,
            VIEW_CAR,
        ),
    },
)
