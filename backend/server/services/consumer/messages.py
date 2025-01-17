import enum


class ConsumerErrorMessages(enum.StrEnum):
    WRONG_PAYLOAD = 'Provided payload is incorrect. Details: {details}'
    FINISHED_WITH_FAILURE = 'Task {name} with id {task_id} raised exception: {exc}\n{einfo}'


class ConsumerMessagesEnum(enum.StrEnum):
    FINISHED_SUCCESSFULLY = 'Task {name} with id {task_id} has been successfully completed'
    ENQUEUED_ACCOUNT_EMAIL_VERIFICATION_TO_MAIL = 'Enqueueing mail for account email verification to sent'
    ENQUEUED_ACCOUNT_PASSWORD_RESET_TO_MAIL = 'Enqueueing mail for account password reset to sent'  # noqa: S105
    ENQUEUED_RESERVATION_CREATE_TO_MAIL = 'Enqueueing mail for reservation create to sent'  # noqa: S105
    ENQUEUED_PAYMENT_SUCCESS_TO_MAIL = 'Enqueueing mail for payment success to sent'  # noqa: S105
    ENQUEUED_PAYMENT_EXPIRED_TO_MAIL = 'Enqueueing mail for payment expired to sent'  # noqa: S105
    ENQUEUED_RESERVATION_CANCEL_TO_MAIL = 'Enqueueing mail for reservation cancel to sent'  # noqa: S105
    ENQUEUED_PAYMENT_REFUND_PROCESSED_TO_MAIL = 'Enqueueing mail for payment refund processed to sent'  # noqa: S105
