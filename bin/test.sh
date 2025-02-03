#!/bin/sh
docker compose run --rm -e DJANGO_ENV=test backend ./test.sh "$@"
