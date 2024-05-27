# Documentation d'implémentation pour la solution d'observabilité

## Vue d'ensemble

Cette documentation explique l'implémentation de notre pile d'observabilité en
utilisant OpenTelemetry, Grafana Alloy, Loki, Tempo et Prometheus. Cette pile
fournit une surveillance et une observabilité complètes pour nos applications
hébergées sur Azure Kubernetes Service (AKS).

## Fonctionnement de Grafana Alloy

Grafana Alloy agit comme le collecteur principal d'OpenTelemetry, agrégeant les
métriques, les journaux et les traces de diverses sources. Il traite les données
collectées et les transmet à Loki, Tempo et Prometheus pour le stockage et la
requête.

## Configuration de Grafana Alloy

La configuration détaillée de Grafana Alloy est disponible à partir de :
[alloy-values.yaml](https://github.com/ai-cfia/howard/blob/d8964d58ad42808b97c5cccc8ee7aaf8fab69b63/kubernetes/aks/system/monitoring/helm/alloy-values.yaml#L28).

### Explication de la configuration

- **otelcol.exporter.otlp** : Configure l'exportateur OTLP pour envoyer des
  données aux points de terminaison spécifiés.
- **otelcol.receiver.otlp** : Configure les récepteurs OTLP pour les protocoles
  gRPC et HTTP, définissant comment les métriques, les journaux et les traces
  sont reçus et transmis.
- **otelcol.processor.memory_limiter** : Implémente un limiteur de mémoire pour
  contrôler l'utilisation de la mémoire, assurant la stabilité.
- **otelcol.processor.batch** : Regroupe les données de télémétrie avant de les
  transmettre pour améliorer les performances et l'efficacité.
- **logging** : Configure le niveau et le format des journaux pour le dépannage
  et la surveillance du fonctionnement d'Alloy.
- **otelcol.exporter.loki** : Configure l'exportateur pour envoyer des journaux
  à Loki.
- **loki.write** : Définit le point de terminaison pour l'envoi des journaux à
  Loki.
- **otelcol.exporter.otlp** : Configure l'exportateur pour envoyer des traces à
  Tempo.
- **otelcol.exporter.prometheus** : Configure l'exportateur pour envoyer des
  métriques à Prometheus.
- **prometheus.remote_write** : Définit le point de terminaison pour l'envoi des
  métriques à Prometheus.

### Exposition des services Alloy

Les ports de service suivants exposent Alloy, le rendant accessible au sein du
cluster Kubernetes :

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

Accessible via : alloy.monitoring.svc.cluster.local

## Instrumentation des métriques, journaux et traces

Pour envoyer des métriques, des journaux et des traces à Grafana Alloy,
configurez vos applications pour utiliser les SDK OpenTelemetry et définissez le
point de terminaison sur alloy.monitoring.svc.cluster.local.

Exemple pour les métriques

```python
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OtlpExporter

metrics.set_meter_provider(MeterProvider())
meter = metrics.get_meter(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

Exemple pour les journaux

```python
from opentelemetry import logs
from opentelemetry.sdk.logs import LogEmitterProvider
from opentelemetry.exporter.otlp.proto.grpc.log_exporter import OtlpExporter

logs.set_log_emitter_provider(LogEmitterProvider())
emitter = logs.get_log_emitter(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

Exemple pour les traces

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OtlpExporter

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)
exporter = OtlpExporter(endpoint="alloy.monitoring.svc.cluster.local:4317")
```

## Transmission des données à Loki, Tempo et Prometheus

Grafana Alloy traite et transmet les données reçues aux backends respectifs.

- Les journaux sont transmis à Loki à
  <http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push>
- Les traces sont transmises à Tempo à
  <http://tempo.monitoring.svc.cluster.local:4317>
- Les métriques sont transmises à Prometheus à
  <http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090/api/v1/write>

## Utilisation de Grafana pour la visualisation

Grafana est disponible à <https://grafana.inspection.alpha.canada.ca>. L'accès
est accordé via l'organisation GitHub de l'agence.

### Configuration de Grafana

1. Connectez-vous à Grafana en utilisant vos identifiants GitHub.
2. Naviguez vers les Tableaux de bord pour explorer différents répertoires tels
que admin, devsecops, finesse, et nachet.
3. Utilisez l'une des trois sources de données :
    - Prometheus pour les métriques Loki pour les journaux
    - Tempo pour les traces

### Création de tableaux de bord

1. Allez à Tableaux de bord > Nouveau tableau de bord.
2. Sélectionnez la source de données (Prometheus, Loki ou Tempo).
3. Créez des visualisations et configurez les panneaux selon vos besoins.

### Tableaux de bord actuels

La plupart des tableaux de bord se trouvent dans le dossier devsecops, y
compris:
    - Surveillance de la santé des nœuds
    - Activité ArgoCD
    - Trafic Ingress-NGINX
    - Scans de vulnérabilités par Trivy et Falco

### Mises à jour futures

Cette documentation sera mise à jour au fur et à mesure que nous incorporerons
des tableaux de bord pour des applications clientes telles que Fertiscan,
Finesse et Nachet.

## Références

- [Documentation OpenTelemetry](https://opentelemetry.io/docs/)
- [SDK Python OpenTelemetry](https://opentelemetry.io/docs/languages/python/)
- [Documentation Grafana](https://grafana.com/docs/grafana/latest/)
- [Documentation Prometheus](https://prometheus.io/docs/)
- [Documentation Loki](https://grafana.com/docs/loki/latest/)
- [Documentation Tempo](https://grafana.com/docs/tempo/latest/)
- [Documentation Grafana Alloy](https://grafana.com/docs/alloy/latest/)
