FROM python:3.11-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV SECRET_KEY=django-insecure-d&owgqcsd&%fc0_%xmwi@iphh_&hjw+e=qyfg866z9e!_9!3vy
ENV CELERY_BROKER_URL = 'redis://localhost:6379'
ENV CELERY_RESULT_BACKEND = 'redis://localhost:6379'

RUN mkdir -p /app/staticfiles && chmod -R 755 /app/staticfiles

EXPOSE 8000

CMD ["sh", "-c", "python manage.py collectstatic --noinput && gunicorn config.wsgi:application --bind 0.0.0.0:8000"]