#!/bin/sh
docker compose run --rm backend python src/manage.py "$@"
