from django.conf import settings
from django.test import TestCase
from django.utils.translation import gettext_lazy as _

from server.utils.api import get_time_str_from_seconds


class TimeHelperTestCase(TestCase):
    max_seconds = settings.MINUTE_IN_SECONDS - 1

    max_minutes_as_seconds = settings.HOUR_IN_SECONDS - settings.MINUTE_IN_SECONDS
    max_minutes = max_minutes_as_seconds // settings.MINUTE_IN_SECONDS

    max_hours_as_seconds = settings.DAY_IN_SECONDS - settings.HOUR_IN_SECONDS
    max_hours = max_hours_as_seconds // settings.HOUR_IN_SECONDS

    def test_get_time_str_from_seconds_when_only_seconds(self):
        expected_time_str = _('{seconds} seconds ').format(seconds=self.max_seconds).strip()

        time_str = get_time_str_from_seconds(value=self.max_seconds)

        assert time_str == expected_time_str

    def test_get_time_str_from_seconds_when_only_minutes(self):
        expected_time_str = _('{minutes} minutes ').format(minutes=self.max_minutes).strip()

        time_str = get_time_str_from_seconds(value=self.max_minutes_as_seconds)

        assert time_str == expected_time_str

    def test_get_time_str_from_seconds_when_only_hours(self):
        expected_time_str = _('{hours} hours ').format(hours=self.max_hours).strip()

        time_str = get_time_str_from_seconds(value=self.max_hours_as_seconds)

        assert time_str == expected_time_str

    def test_get_time_str_from_seconds_when_only_days(self):
        timestamp = settings.DAY_IN_SECONDS
        days = timestamp // settings.DAY_IN_SECONDS
        expected_time_str = _('{days} days ').format(days=days).strip()

        time_str = get_time_str_from_seconds(value=timestamp)

        assert time_str == expected_time_str

    def test_get_time_str_from_seconds(self):
        timestamp = (
            settings.DAY_IN_SECONDS +
            self.max_hours_as_seconds +
            self.max_minutes_as_seconds +
            self.max_seconds
        )

        days = timestamp // settings.DAY_IN_SECONDS

        expected_time_str = (
            _('{days} days ').format(days=days) +
            _('{hours} hours ').format(hours=self.max_hours) +
            _('{minutes} minutes ').format(minutes=self.max_minutes) +
            _('{seconds} seconds ').format(seconds=self.max_seconds)
        ).strip()

        time_str = get_time_str_from_seconds(value=timestamp)

        assert time_str == expected_time_str
