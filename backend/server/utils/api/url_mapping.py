import re

from django.conf import settings


def get_frontend_url(backend_url_path: str) -> str:
    frontend_url_path = re.sub(pattern=r'api(/v\d+)?/', repl='', string=backend_url_path, count=1)

    return ''.join([settings.FRONTEND_DOMAIN, frontend_url_path])
