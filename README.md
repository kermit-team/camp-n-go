# Camp-n-go
App for camping management

## Initialization 
Local environment is handled by docker compose. 
List of services:
- backend (Django)
- frontend (Angular)
- database (PostgreSQL)

To initialize local development server you should run script `bin/dev_init.sh`.

## Running 
Local development server should be run with script `bin/run.sh`.

To get into backend server you should run script `bin/enter.sh`.

In order to manage poetry you should run script `bin/poetry.sh`.

If there's a need to clear local environment, you can run script `bin/dev_clear.sh`.

## Scripts
Scripts are located inside **bin** directory.

`dev_clear.sh` - Handles clearing local development server docker container, images, volumes and delete.

`dev_init.sh` - Handles setting up local development server by creating env files and using docker compose 
any existing env file.

`enter.sh` - Handles getting into running backend service terminal.

`entrypoint.dev.sh` - Handles running development backend service (compile translation messages, migrate database 
models and starts server).

`manage.sh` - Handles running scripts/commands for backend service.

`poetry.sh` - Handles running commands for Poetry inside backend service.

`run.sh` - Handles running local development server using docker compose.

