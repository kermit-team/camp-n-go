from types import MappingProxyType

STRIPE_EVENT_TYPES_MAPPING: MappingProxyType[str, str] = MappingProxyType(
    {
        'COMPLETED': 'checkout.session.completed',
        'EXPIRED': 'checkout.session.expired',
        'REFUNDED': 'charge.refunded',
    },
)
