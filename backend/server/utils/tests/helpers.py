from logging import Logger


def get_formatted_log(msg: str, level: str, logger: Logger) -> str:  # pragma: no cover
    return '{level}:{logger_name}:{msg}'.format(
        level=level,
        msg=msg,
        logger_name=logger.name,
    )


def is_log_in_logstream(log: str, output: list[str]) -> bool:  # pragma: no cover
    for record in output:
        if log in record:
            return True
    return False
