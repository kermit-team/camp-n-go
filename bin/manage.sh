#!/bin/sh
docker compose run --rm backend python manage.py "$@"
