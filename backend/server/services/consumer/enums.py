import enum


class ConsumerMessages(enum.StrEnum):
    START_CONSUMING = 'The {mode} consumer is listening on {host}:{port} looking for routing keys {keys} in exchange {exchange}'  # noqa: E501


class TaskNameEnum(enum.StrEnum):
    MAILING = 'MailingTask'
    RESERVATIONS_REMINDER_DAILY_DISPATCHER = 'ReservationsReminderDailyDispatcherTask'
