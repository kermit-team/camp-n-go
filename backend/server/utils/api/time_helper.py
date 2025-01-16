from django.conf import settings
from django.utils.translation import gettext_lazy as _


def get_time_str_from_seconds(value: int) -> str:
    days, seconds = divmod(value, settings.DAY_IN_SECONDS)
    hours, seconds = divmod(value, settings.HOUR_IN_SECONDS)
    minutes, seconds = divmod(value, settings.MINUTE_IN_SECONDS)

    expiration_time = ''
    if days > 0:
        expiration_time += _('{days} days').format(days=days)
    if hours > 0:
        expiration_time += _('{hours} hours').format(hours=hours)
    if minutes > 0:
        expiration_time += _('{minutes} minutes').format(minutes=minutes)
    if seconds > 0:
        expiration_time += _('{seconds} seconds').format(seconds=seconds)

    return expiration_time
