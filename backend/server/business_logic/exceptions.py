from server.services.consumer.exceptions import BaseConsumerWithRejectError


class DatabaseConnectionError(BaseConsumerWithRejectError):
    pass  # noqa: WPS420, WPS604


class DatabaseDataIntegrityError(BaseConsumerWithRejectError):
    pass  # noqa: WPS420, WPS604
