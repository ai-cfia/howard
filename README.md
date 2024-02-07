# Infrastructure Repository for ACIA-CFIA AI-Lab

This repository contains all the infrastructure used by the ACIA/CFIA AI Lab.
In this repository, you can find the Kubernetes manifests that deploy each of
the applications on the three different cloud providers: Google Cloud Platform
(GCP), Amazon Web Services (AWS), and Azure.

## Documentation

For more information about this project, you can refer to the documentation
which contains explanations as well as diagrams:

- [Global overview](docs/global_overview.md)
- [Ingress](docs/ingress.md)

## Content

- The Terraform configuration for the GCP cluster.
- Kubernetes manifests used to deploy the following applications:
    - [Nachet backend](https://github.com/ai-cfia/nachet-backend)
    - [Nachet frontend](https://github.com/ai-cfia/nachet-frontend)
    - [Finesse backend](https://github.com/ai-cfia/finesse-backend)
    - [Finesse frontend](https://github.com/ai-cfia/finesse-frontend)
- Configuration for Vault, Grafana, Prometheus, Alert Manager, Ingress NGINX,
and Cert Manager to meet our requirements.

## Tooling

- [Hashicorp Vault](https://www.vaultproject.io/)
- [Grafana](https://grafana.com/)
- [Prometheus](https://prometheus.io/docs/visualization/grafana/)
- [Alert manager](https://github.com/prometheus/alertmanager)
- [Cert manager](https://cert-manager.io/)
- [Ingress NGINX](https://docs.nginx.com/nginx-ingress-controller/)
- [OTEL](https://opentelemetry.io/)

## Useful links

[ai-cfia github container registry](https://github.com/orgs/ai-cfia/packages)
