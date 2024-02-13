# Infrastructure Repository for ACIA-CFIA AI-Lab

This repository contains all the infrastructure used by the ACIA/CFIA AI Lab.
In this repository, you can find the Kubernetes manifests that deploy each of
the applications on the three different cloud providers: Google Cloud Platform
(GCP), Amazon Web Services (AWS), and Azure.

## Dependencies

- [Terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [kubelogin](https://github.com/Azure/kubelogin)

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

## Liens utiles

[ai-cfia github container registry](https://github.com/orgs/ai-cfia/packages)

## Terraform Deployment

Current configuration is hosting a kubernetes cluster on Azure (AKS). We have an
Azure Devops pipeline `apply-terraform.yml` that applies terraform's resources
that are created on our Azure's subscription. The state is then saved to a blob
storage in Azure.

## Kubectl configuration

Assuming you have [Azure's
CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) and
[kubelogin](https://github.com/Azure/kubelogin) plugin installed, here is how
you can locally fetch the kube config :

```bash
az login
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
az aks get-credentials --resource-group resource-group-name --name aks-name --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```
