FROM python:3.8-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG ARG_OTEL_VERSION
ARG ARG_LOKI_VERSION

ENV OTEL_ENDPOINT=${ARG_OTEL_VERSION:-alloy.monitoring.svc.cluster.local:4317}
ENV LOKI_ENDPOINT=${ARG_LOKI_VERSION:-http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push}

COPY test_app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY test_app/ .

EXPOSE 5000

CMD ["python", "app.py"]
