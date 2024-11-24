# Camp-n-go
Backend web application for camping management built with Django REST Framework.

## Scripts
Scripts are located inside **bin** directory.

| Script              | Comment                                                               |
|---------------------|-----------------------------------------------------------------------|
| check.sh            | Is running flake8, xenon, pip-audit, bandit, mypy, migrations checks. |
| create_users.sh     | Is creating superuser and users for each group.                       |
| enter.sh            | Is connecting to backend container.                                   |
| entrypoint.dev.sh   | Is starting development sever.                                        |
| isort.sh            | Is for sort imports in python files.                                  |
| manage.sh           | Is running manage.py with optional parameters.                        |
| poetry.sh           | Is running poetry inside container.                                   |
| run_consumer.dev.sh | Is running Celery worker for given queue.                             |
| test.sh             | Is running tests with coverage .                                      |

## Commands
There are implemented some Django CLI commands simplifying instance management.

In order to list all available commands divided by an application that they concern use:
```bash
bin/manage.sh --help
```

To run any of the commands type:
```bash
bin/manage.sh <command> <params>
```
where `<command>` is one of the names listed in the help command and `params` is required or optional 
params specified individually for a command. In order to find out the exact signature of a command type:
```bash
bin/manage.sh <command> --help
```

Note that `bin/manage.sh` runs `python manage.py` with params inside the service container so if you 
want to run  the commands from the inside of the container use `python manage.py` instead of `bin/manage.sh`.

Below there are listed custom commands available for this service.

| Command                  | Comment                                                       |
|--------------------------|---------------------------------------------------------------|
| create_account           | Create account based on the given details.                    |
| create_superuser_account | Create superuser account based on the given details.          |
| load_permissions         | Fill database with defined permissions.                       |
| load_groups              | Fill database with defined groups and associated permissions. |
