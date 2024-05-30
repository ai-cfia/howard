# Implementation documentation for observability Solution

## Overview

This documentation explains the implementation of our observability stack using
OpenTelemetry, Grafana Alloy, Loki, Tempo, and Prometheus. This stack provides
comprehensive monitoring and observability for our applications hosted on Azure
Kubernetes Service (AKS).

## How Grafana Alloy works

Grafana Alloy acts as the primary OpenTelemetry collector, aggregating metrics,
logs, and traces from various sources. It processes the collected data and
forwards it to Loki, Tempo, and Prometheus for storage and querying.

## Configuration of Grafana Alloy

The detailed configuration of Grafana Alloy is available from:
[alloy-values.yaml](https://github.com/ai-cfia/howard/blob/d8964d58ad42808b97c5cccc8ee7aaf8fab69b63/kubernetes/aks/system/monitoring/helm/alloy-values.yaml#L28).

### Explanation of the configuration

- **otelcol.exporter.otlp**: Configures the OTLP exporter to send data to
  specified endpoints.
- **otelcol.receiver.otlp**: Sets up OTLP receivers for gRPC and HTTP protocols,
  defining how metrics, logs, and traces are received and forwarded.
- **otelcol.processor.memory_limiter**: Implements a memory limiter to control
  memory usage, ensuring stability.
- **otelcol.processor.batch**: Batches telemetry data before forwarding to
  improve performance and efficiency.
- **logging**: Configures logging level and format for troubleshooting and
  monitoring Alloy’s operation.
- **otelcol.exporter.loki**: Configures the exporter to send logs to Loki.
- **loki.write**: Defines the endpoint for sending logs to Loki.
- **otelcol.exporter.otlp**: Configures the exporter to send traces to Tempo.
- **otelcol.exporter.prometheus**: Configures the exporter to send metrics to
  Prometheus.
- **prometheus.remote_write**: Defines the endpoint for sending metrics to
  Prometheus.

### Exposing Alloy services

The following service ports expose Alloy, making it accessible within the
Kubernetes cluster:

```yaml
- name: "grpc"
  port: 4317
  targetPort: 4317
  protocol: "TCP"
- name: "http"
  port: 4318
  targetPort: 4318
  protocol: "TCP"
```

Accessible via: alloy.monitoring.svc.cluster.local

## Instrumentation of Metrics, Logs, and Traces

To send metrics, logs, and traces to Grafana Alloy, configure your applications
to use the OpenTelemetry SDKs and set the endpoint to
alloy.monitoring.svc.cluster.local.

Example for Metrics

```python
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OtlpExporter

metrics.set_meter_provider(MeterProvider())
meter = metrics.get_meter(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

Example for Logs

```python
from opentelemetry import logs
from opentelemetry.sdk.logs import LogEmitterProvider
from opentelemetry.exporter.otlp.proto.grpc.log_exporter import OtlpExporter

logs.set_log_emitter_provider(LogEmitterProvider())
emitter = logs.get_log_emitter(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

Example for Traces

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OtlpExporter

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

## Forwarding Data to Loki, Tempo, and Prometheus

Grafana Alloy processes and forwards the received data to the respective
backends.

- Logs are forwarded to Loki at
  `http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push`
- Traces are forwarded to Tempo at
  `http://tempo.monitoring.svc.cluster.local:4317`
- Metrics are forwarded to Prometheus at
  `http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090/api/v1/write`

## Using Grafana for Visualization

Grafana is available at <https://grafana.inspection.alpha.canada.ca>. Access is
granted through the agency's GitHub organization.

### Setting Up Grafana

1. Login to Grafana using your GitHub credentials.
2. Navigate to Dashboards to explore different directories like admin,
   devsecops, finesse, and nachet.
3. Use one of the three data sources:
    - Prometheus for metrics
    - Loki for logs
    - Tempo for traces

### Creating Dashboards

1. Go to Dashboards > New Dashboard.
2. Select the data source (Prometheus, Loki, or Tempo).
3. Create visualizations and configure panels as needed.

### Current Dashboards

Most dashboards are under the devsecops folder, including:

- Node Health Monitoring
- ArgoCD Activity
- Ingress-NGINX Traffic
- Vulnerability Scans by Trivy and Falco

### Future Updates

This documentation will be updated as we incorporate dashboards for client
applications such as Fertiscan, Finesse and Nachet.

## References

- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
- [Python OpenTelemetry SDK](https://opentelemetry.io/docs/languages/python/)
- [Grafana documentation](https://grafana.com/docs/grafana/latest/)
- [Prometheus documentation](https://prometheus.io/docs/)
- [Loki documentation](https://grafana.com/docs/loki/latest/)
- [Tempo documentation](https://grafana.com/docs/tempo/latest/)
- [Grafana Alloy documentation](https://grafana.com/docs/alloy/latest/)
