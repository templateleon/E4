#!/bin/bash

django-admin startproject Dj_proj
rm Dj_proj/Dj_proj/settings.py && mv settings.py Dj_proj/Dj_proj/
cd Dj_proj 
mkdir static

python manage.py collectstatic

service postgresql start

python manage.py migrate --no-input
python manage.py createsuperuser --no-input

service nginx start
gunicorn Dj_proj.wsgi:application --bind 0.0.0.0:8000


#-------------------------
#python manage.py runserver 0.0.0.0:8000

## Ожидание (проверка) доступности PostgreSQL
#while ! pg_isready -q -h localhost -p 5432 -U db_user
#do
#    sleep 1
#done
#-------------------------
