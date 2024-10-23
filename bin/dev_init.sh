#!/bin/sh
set -e
cp -n envs/backend-env-default envs/.backend.env
cp -n envs/database-env-default envs/.database.env
cp -n envs/frontend-env-default envs/.frontend.env

docker compose up -d

sleep 5

echo "Migrating data for django database..."
./bin/manage.sh migrate
