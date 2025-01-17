from datetime import date

from server.apps.common.errors.common import CommonErrorMessagesEnum


class InvalidDateValuesError(Exception):
    def __init__(self, date_from: date, date_to: date):
        super().__init__(
            CommonErrorMessagesEnum.INVALID_DATE_VALUES.value.format(date_from=date_from, date_to=date_to),
        )


class DateInThePastError(Exception):
    def __init__(self, given_date: date):
        super().__init__(
            CommonErrorMessagesEnum.DATE_IN_THE_PAST.value.format(given_date=given_date),
        )
