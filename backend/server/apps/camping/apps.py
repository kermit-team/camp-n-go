from django.apps import AppConfig
from django.utils.translation import gettext_lazy as _


class CampingConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'server.apps.camping'
    verbose_name = _('Camping')
    verbose_name_plural = _('Campings')
