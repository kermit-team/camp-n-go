from typing import Optional

from pydantic import BaseModel


class FileInfo(BaseModel):
    filename: str
    path: str


class MailingSerializer(BaseModel):
    to_email: list[str]
    subject: str
    html_message: str
    files: Optional[list[FileInfo]] = None
