FROM python:3.10-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_EMAIL=admin@example.com
ENV DJANGO_SUPERUSER_PASSWORD=admin

RUN apt-get update && apt-get install -y nginx postgresql postgresql-contrib

RUN mkdir /Dj_server

WORKDIR /Dj_server

VOLUME ["/Dj_server", "/var/lib/postgresql"]

COPY requirements.txt .
COPY settings.py .
COPY nginx_dj.conf /etc/nginx/conf.d/Dj_server.conf
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN pip install -r requirements.txt

RUN service postgresql start &&  \
    su - postgres -c "psql -c \"CREATE DATABASE dj_db;\"" && \
    su - postgres -c "psql -c \"CREATE USER db_user WITH PASSWORD 'db_pass';\"" && \
    su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE dj_db TO db_user;\""

EXPOSE 80 5432 8000

ENTRYPOINT ["./entrypoint.sh"]

