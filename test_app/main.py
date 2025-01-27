import os
import logging
import logging_loki

from minio import Minio
from minio.error import S3Error

from flask import Flask, jsonify, request
from dotenv import load_dotenv

from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.metrics import MeterProvider, Counter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter

OTEL_ENDPOINT = os.getenv("OTEL_ENDPOINT")
LOKI_ENDPOINT = os.getenv("LOKI_ENDPOINT")

MINIO_URL = os.getenv("MINIO_URL")
MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY")

# Tracer
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)
trace_exporter = OTLPSpanExporter(endpoint=OTEL_ENDPOINT, insecure=True)
trace_processor = BatchSpanProcessor(trace_exporter)
trace.get_tracer_provider().add_span_processor(trace_processor)

# Metrics
metrics.set_meter_provider(MeterProvider())
meter = metrics.get_meter(__name__)
metric_exporter = OTLPMetricExporter(endpoint=OTEL_ENDPOINT, insecure=True)

request_counter = meter.create_counter(
    name="request_counter",
    description="Compte les requêtes sur le serveur"
)

# Loki logs (INFO level)
loki_handler = logging_loki.LokiHandler(
    url=LOKI_ENDPOINT,
    tags={"application": "test-app"},
    version="1",
)
logger = logging.getLogger("flask-app")
logger.setLevel(logging.DEBUG)
logger.addHandler(loki_handler)

# minIO configuration
client = Minio(
    endpoint=MINIO_URL,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=False
)

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)

@app.route('/metrics', methods=['POST'])
def increment_metric():
    action = request.json.get("action")
    if action == "increment":
        request_counter.add(1, {"endpoint": "/metrics"})
        logger.info("info: metric incremented")
    elif action == "reset":
        request_counter = meter.create_counter(
            name="request_counter",
            description="Compte les requêtes sur le serveur"
        )
        logger.info("info: metric reset")
    else:
        logger.critical("critical: error in /metrics")
        return jsonify({"error": "action not found."}), 400
    return jsonify({"message": "ok"}), 200

@app.route('/ok', methods=['GET'])
def ok():
    with tracer.start_as_current_span("200-response"):
        logger.info("info: /ok endpoint")
        return jsonify({"message": "ok"}), 200

@app.route('/not_found', methods=['GET'])
def not_found():
    with tracer.start_as_current_span("404-response"):
        logger.info("info: /not-found endpoint")
        return jsonify({"error": "Not found"}), 404

@app.route('/error', methods=['GET'])
def error():
    with tracer.start_as_current_span("500-response"):
        logger.critical("critical: /error endpoint")
        return jsonify({"error": "Internal server error"}), 500

@app.route('/minio', methods=['GET'])
def minio():
    bucket_name = "howard-test-app"
    file_name = "my_file.txt"
    file_content = "Testing minIO with the howard test application."

    try:
        if not client.bucket_exists(bucket_name):
            print(f"info: the bucket name '{bucket_name}' doesn't exist.")

        with open(file_name, "w") as file:
            file.write(file_content)

        client.fput_object(bucket_name, file_name, file_name)
        print(f"info: file '{file_name}' uploaded to '{bucket_name}'.")

    except S3Error as e:
        print("error: S3:", e)

if __name__ == '__main__':
    load_dotenv()
    app.run(host='0.0.0.0', port=5000)
