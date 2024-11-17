#!/bin/sh

set -e -u

cd /code

echo "Migrating database..."
python manage.py migrate --noinput

echo "Compiling messages..."
python manage.py compilemessages

echo "Loading permissions..."
python manage.py load_permissions

echo "Loading groups..."
python manage.py load_groups

echo "Running server..."
python manage.py runserver 0.0.0.0:8000
