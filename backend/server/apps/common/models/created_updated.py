from django.db import models
from django.utils.translation import gettext_lazy as _


class CreatedUpdatedMixin(models.Model):
    created_at = models.DateTimeField(_('CreatedAt'), auto_now_add=True)
    modified_at = models.DateTimeField(_('ModifiedAt'), auto_now=True)

    class Meta(object):
        abstract = True
