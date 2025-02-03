#!/bin/sh
if [ "$DJANGO_ENV" != 'development' ]; then
  echo "DJANGO_ENV is not set to 'development'. Creating hardcoded users is forbidden!"
  exit 1
fi

echo "Creating superuser account..."
python manage.py create_superuser_account \
  --email "admin@example.com" \
  --password "Q@werty123!" \
  --first_name "Patryk" \
  --last_name "Beberok"

echo "Creating users for each permission group..."

python manage.py create_account \
  --email "owner@example.com" \
  --password "Q@werty123!" \
  --first_name "Anon" \
  --last_name "Właściciel" \
  --phone_number "+48999999998" \
  --id_card "XYZ 123455" \
  --group_names "Właściciel"

python manage.py create_account \
  --email "employee@example.com" \
  --password "Q@werty123!" \
  --first_name "Anon" \
  --last_name "Pracownik" \
  --phone_number "+48999999997" \
  --id_card "XYZ 123454" \
  --group_names "Pracownik"

python manage.py create_account \
  --email "client@example.com" \
  --password "Q@werty123!" \
  --first_name "Anon" \
  --last_name "Klient" \
  --phone_number "+48999999996" \
  --id_card "XYZ 123453" \
  --group_names "Klient"
