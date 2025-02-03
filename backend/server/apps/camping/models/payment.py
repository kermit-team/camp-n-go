from django.conf import settings
from django.core.validators import MinValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _

from server.apps.common.models.created_updated import CreatedUpdatedMixin


class PaymentStatus(models.IntegerChoices):
    WAITING_FOR_PAYMENT = 0, _('WaitingForPayment')
    CANCELLED = 1, _('Cancelled')
    UNPAID = 2, _('Unpaid')
    PAID = 3, _('Paid')
    REFUNDED = 4, _('Refunded')


class Payment(CreatedUpdatedMixin):
    _name_schema = '{stripe_checkout_id} - {status} [price]'

    status = models.IntegerField(
        choices=PaymentStatus,
        default=PaymentStatus.WAITING_FOR_PAYMENT,
    )
    stripe_checkout_id = models.CharField(
        verbose_name=_('StripeCheckoutId'),
        max_length=settings.LARGE_LENGTH,
        unique=True,
    )
    price = models.DecimalField(
        verbose_name=_('Price'),
        max_digits=settings.RESERVATION_PRICE_DIGITS,
        decimal_places=settings.PRICE_DECIMAL_PLACES,
        validators=[MinValueValidator(settings.PRICE_MIN_VALUE)],
    )

    def __str__(self) -> str:  # pragma: no cover
        name = self._name_schema.format(
            stripe_checkout_id=self.stripe_checkout_id,
            status=self.get_status_display(),
            price=self.price,
        )
        return name.strip()
