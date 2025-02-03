#!/bin/sh
if [ "$DJANGO_ENV" != 'development' ]; then
  echo "DJANGO_ENV is not set to 'development'. Creating hardcoded camping sections is forbidden!"
  exit 1
fi

echo "Creating default camping sections..."

python manage.py create_camping_section \
  --name "A" \
  --base_price "400.00" \
  --price_per_adult "50.00" \
  --price_per_child "25.00"

python manage.py create_camping_section \
  --name "B" \
  --base_price "300.00" \
  --price_per_adult "40.00" \
  --price_per_child "20.00"

python manage.py create_camping_section \
  --name "C" \
  --base_price "200.00" \
  --price_per_adult "30.00" \
  --price_per_child "10.00"

python manage.py create_camping_section \
  --name "D" \
  --base_price "100.00" \
  --price_per_adult "25.00" \
  --price_per_child "10.00"
