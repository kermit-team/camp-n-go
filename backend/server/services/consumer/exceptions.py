from server.services.consumer.messages import ConsumerErrorMessages


class BaseConsumerWithAcknowledgeError(Exception):
    pass  # noqa: WPS420 WPS604


class BaseConsumerWithRejectError(Exception):
    pass  # noqa: WPS420 WPS604


class WrongPayloadError(BaseConsumerWithAcknowledgeError):
    def __init__(self, details: str):
        super().__init__(
            ConsumerErrorMessages.WRONG_PAYLOAD.value.format(details=details),
        )
