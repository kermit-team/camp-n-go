#!/bin/sh

set -o errexit
set -o nounset

cd /code/src

echo "Migrating database..."
python manage.py migrate --noinput

echo "Compiling messages..."
python manage.py compilemessages

echo "Running server..."
python manage.py runserver 0.0.0.0:8000
