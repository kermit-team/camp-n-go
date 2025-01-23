import uuid
from abc import ABC, abstractmethod


class AbstractDispatcher(ABC):
    def __init__(self, task_id: uuid.UUID) -> None:
        self.task_id = task_id

    @abstractmethod
    def dispatch(self, *args, **kwargs) -> None:
        raise NotImplementedError()
