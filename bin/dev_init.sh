#!/bin/sh
set -e
cp -n envs/backend-env-default envs/.backend.env
cp -n envs/database-env-default envs/.database.env
cp -n envs/frontend-env-default envs/.frontend.env

docker compose up -d

sleep 5

echo "Migrating database..."
bin/manage.sh migrate --noinput

echo "Compiling messages..."
bin/manage.sh compilemessages

echo "Loading permissions..."
bin/manage.sh load_permissions

echo "Loading groups..."
bin/manage.sh load_groups

echo "Creating users..."
bin/create_users.sh
