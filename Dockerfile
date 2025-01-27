FROM python:3.8-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG ARG_OTEL_VERSION
ARG ARG_LOKI_VERSION
ARG ARG_MINIO_URL
ARG ARG_MINIO_ACCESS_KEY
ARG ARG_MINIO_SECRET_KEY

ENV OTEL_ENDPOINT=${ARG_OTEL_VERSION:-alloy.monitoring.svc.cluster.local:4317}
ENV LOKI_ENDPOINT=${ARG_LOKI_VERSION:-http://loki-gateway.monitoring.svc.cluster.local:80/loki/api/v1/push}
ENV MINIO_URL=${ARG_MINIO_URL:-minio.minio.svc.cluster.local:9000}
ENV MINIO_ACCESS_KEY=${ARG_MINIO_ACCESS_KEY:-arg_minio_access_key}
ENV MINIO_SECRET_KEY=${ARG_MINIO_SECRET_KEY:-arg_minio_secrey_key}

COPY test_app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY test_app/ .

RUN adduser --disabled-password --gecos "" --uid 1000 appuser

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["python", "main.py"]
