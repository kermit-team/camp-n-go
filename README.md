# Camp-n-go
App for camping management

## Initialization 
Local environment is handled by docker compose. 
List of services:
- database (PostgreSQL)
- frontend (Angular)
- backend (Django)
- rabbitmq (RabbitMQ - message broker)
- flower (Flower - Celery monitoring)
- smtp_server (Mailhog - fake smtp server)
- worker (Celery worker - handles tasks in backend)

To initialize local development server you should run script 
```bash
bin/dev_init.sh
```

## Running 
Local development server should be run with script `run.sh`.

If there's a need to clear local environment, you can run script 
```bash
bin/dev_clear.sh
```

## Scripts
Scripts are located inside **bin** directory.


| Script                      | Comment                                      |
|-----------------------------|----------------------------------------------|
| dev_clear.sh                | Is deleting all development environment.     |
| dev_init.sh                 | Is creating all development environment.     |
| enter.sh                    | Is running existing development environment. |

## Environment variables
Environment variables are stored in grouped files. 
These files can be used by multiple services because of related settings.

| Name                                | Default                                                                                 | Description                                                                                                      |
|-------------------------------------|-----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| DEBUG                               | 1                                                                                       | Sets the DEBUG variable - 0 or 1                                                                                 |
| DJANGO_ENV                          | development                                                                             | Sets the DJANGO_ENV variable - development or production                                                         |
| SECRET_KEY                          | 'PLEASE-CHANGE-THIS'                                                                    | Sets the SECRET_KEY variable                                                                                     |
| ALLOWED_HOSTS                       | localhost 127.0.0.1 [::1]                                                               | Sets the ALLOWED_HOSTS variable - splitted by space                                                              |
| CSRF_TRUSTED_ORIGINS                | http://localhost http://127.0.0.1                                                       | Sets the CSRF_TRUSTED_ORIGINS variable - splitted by space                                                       |
| CORS_ALLOWED_ORIGINS                | http://localhost:8000 http://127.0.0.1:8000 http://localhost:4200 http://127.0.0.1:4200 | Sets the CORS_ALLOWED_ORIGINS variable - splitted by space                                                       |
| DJANGO_SILK_ON                      | 0                                                                                       | Adds django-silk features to the project                                                                         |
| DRF_SPECTACULAR_ON                  | 0                                                                                       | Adds Django REST Framework Spectacular (OpenAPI 3 schema docs with SwaggerUI)                                    |
| POSTGRES_HOST                       | database                                                                                | Sets the POSTGRES_HOST                                                                                           |
| POSTGRES_PORT                       | 5432                                                                                    | Sets the POSTGRES_PORT                                                                                           |
| POSTGRES_USER                       | postgres_user                                                                           | Sets the POSTGRES_USER                                                                                           |
| POSTGRES_PASSWORD                   | postgres_password                                                                       | Sets the POSTGRES_PASSWORD                                                                                       |
| POSTGRES_DB                         | postgres_db                                                                             | Sets the POSTGRES_DB                                                                                             |
| EMAIL_BACKEND                       | CONSOLE                                                                                 | The string mapping for django email backend (possible options: SMTP, CONSOLE, FILE, IN_MEMORY, DUMMY).           |
| EMAIL_HOST_USER                     |                                                                                         | The e-mail used for mailing system as the sender.                                                                |
| EMAIL_HOST_PASSWORD                 |                                                                                         | The password for the email host user.                                                                            |
| EMAIL_HOST                          |                                                                                         | The host address used for mailing system.                                                                        |
| EMAIL_PORT                          |                                                                                         | The host port used for mailing system.                                                                           |
| CELERY_BROKER_URL                   | amqp://guest:guest@rabbitmq:5672/                                                       | The URL of message broker used by Celery.                                                                        |
| MAX_RETRIES                         | 5                                                                                       | The number of maximal Celery task retries when it fails.                                                         |
| DEFAULT_TASK_RETRY_DELAY_IN_SECONDS | 5                                                                                       | The value of delay (in seconds) for Celery task to retry.                                                        |
| MAILING_QUEUE                       | celery                                                                                  | The name of the queue used for mailing tasks.                                                                    |
| FRONTEND_DOMAIN                     |                                                                                         | The domain used by frontend application. It is used for creating backend matching URLs for frontend application. |
| REST_PAGE_SIZE                      | 10                                                                                      | The number of items returned by REST API (where pagination is used).                                             |
| ACCESS_TOKEN_LIFETIME_IN_SECONDS    | 60 * 30                                                                                 | The Access Token lifetime value (in seconds).                                                                    |
| REFRESH_TOKEN_LIFETIME_IN_SECONDS   | 60 * 60 * 24                                                                            | The Refresh Token lifetime value (in seconds).                                                                   |
| PASSWORD_RESET_TIMEOUT_IN_SECONDS   | 60 * 60 * 24                                                                            | The Password Reset Token lifetime value (in seconds). Affects also the Email Verification Token.                 |
