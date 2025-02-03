from pydantic import BaseModel


class AccountViewPermissions(BaseModel):
    anon: bool = False
    account: bool = False
    owner: bool = False
    employee: bool = False
    client: bool = False
    superuser: bool = True
