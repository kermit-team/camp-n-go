class AbstractBL:
    def __init__(self, correlation_id: str | None = None):
        self.correlation_id = correlation_id
