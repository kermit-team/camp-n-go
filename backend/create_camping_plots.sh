#!/bin/sh
if [ "$DJANGO_ENV" != 'development' ]; then
  echo "DJANGO_ENV is not set to 'development'. Creating hardcoded camping plots is forbidden!"
  exit 1
fi

echo "Creating default camping plots for each section..."

python manage.py create_camping_plot \
  --position "1" \
  --max_number_of_people 10 \
  --width "10.00" \
  --length "5.00" \
  --camping_section_name "A" \
  --water_connection \
  --electricity_connection \
  --is_shaded \
  --grey_water_discharge \
  --description "Parcel premium w sekcji A"

python manage.py create_camping_plot \
  --position "2" \
  --max_number_of_people 8 \
  --width "8.00" \
  --length "4.00" \
  --camping_section_name "A" \
  --water_connection \
  --electricity_connection \
  --grey_water_discharge \
  --description "Parcel standard w sekcji A"

python manage.py create_camping_plot \
  --position "1" \
  --max_number_of_people 8 \
  --width "8.00" \
  --length "4.00" \
  --camping_section_name "B" \
  --water_connection \
  --electricity_connection \
  --is_shaded \
  --grey_water_discharge \
  --description "Parcel premium w sekcji B"

python manage.py create_camping_plot \
  --position "2" \
  --max_number_of_people 6 \
  --width "7.50" \
  --length "3.50" \
  --camping_section_name "B" \
  --water_connection \
  --electricity_connection \
  --grey_water_discharge \
  --description "Parcel standard w sekcji B"

python manage.py create_camping_plot \
  --position "1" \
  --max_number_of_people 6 \
  --width "7.50" \
  --length "3.50" \
  --camping_section_name "C" \
  --water_connection \
  --is_shaded \
  --grey_water_discharge \
  --description "Parcel premium w sekcji C"

python manage.py create_camping_plot \
  --position "2" \
  --max_number_of_people 6 \
  --width "7.50" \
  --length "3.50" \
  --camping_section_name "C" \
  --water_connection \
  --grey_water_discharge \
  --description "Parcel standard w sekcji C"

python manage.py create_camping_plot \
  --position "1" \
  --max_number_of_people 6 \
  --width "6.00" \
  --length "3.00" \
  --camping_section_name "D" \
  --water_connection \
  --is_shaded \
  --description "Parcel premium w sekcji D"

python manage.py create_camping_plot \
  --position "2" \
  --max_number_of_people 6 \
  --width "6.00" \
  --length "3.00" \
  --camping_section_name "D" \
  --water_connection \
  --description "Parcel standard w sekcji D"
