import enum


class ConsumerErrorMessages(enum.StrEnum):
    WRONG_PAYLOAD = 'Provided payload is incorrect. Details: {details}'
    FINISHED_WITH_FAILURE = 'Task {name} with id {task_id} raised exception: {exc}\n{einfo}'


class ConsumerMessagesEnum(enum.StrEnum):
    FINISHED_SUCCESSFULLY = 'Task {name} with id {task_id} has been successfully completed'
    ENQUEUED_ACCOUNT_EMAIL_VERIFICATION_TO_MAIL = 'Enqueueing mail for account email verification to sent'
