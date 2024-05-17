# Howard: Cloud infrastructure of the Canadian Food Inspection Agency (CFIA) ACIA-CFIA ai-Lab

## About the project

The Howard project is named after Luke Howard, FRS, a notable British
manufacturing chemist and amateur meteorologist known as "The Godfather of
Clouds". His work laid foundational concepts in meteorology, including a
nomenclature system for clouds introduced in 1802. Inspired by his innovation
and legacy in categorizing the elements, our project aims to effectively manage
and orchestrate the cloud-based infrastructure for the Canadian Food Inspection
Agency (CFIA) ai-lab.

Howard is essentially the backbone that supports CFIA's ai-lab Kubernetes environment,
where key applications such as Nachet, Finesse, and Louis are deployed and
managed dynamically. This infrastructure emphasizes robustness, security, and
efficiency to handle the critical workload involved in food inspection
and safety.

## Technology stack and tools

The Howard infrastructure leverages a comprehensive suite of tools designed to
provide a resilient, secure, and scalable environment:

### Cloud providers

- Initially hosted on Google Cloud, the infrastructure has transitioned to
Azure.

### Container orchestration

- **Kubernetes**: Orchestrates container deployment, scaling, and management.

### GitOps

- **ArgoCD**: Used for continuous delivery, managing Kubernetes resources in
a declarative way through Git repositories.

### Monitoring and security

- **Grafana**: Visualization and analytics software.
- **Kube-Prometheus-Stack**: Comprehensive Kubernetes cluster monitoring
with Prometheus.
- **Falco**: Open-source runtime security tool.
- **Trivy**: Vulnerability scanner for containers.
- **Oneuptime**: Monitoring tool for real-time performance and security insights.

### Networking

- **Vouch-Proxy**: Authentication proxy.
- **Nginx Ingress**: Ingress controller for Kubernetes using NGINX as a
reverse proxy and load balancer.
- **Istio**: Service mesh that provides a secure interface for inter-service communication.

### Secrets management

- **HashiCorp Vault**: Secures, stores, and tightly controls access to tokens,
passwords, certificates, and other secrets.

### Cloud infrastructure management

- **Terraform**: Open-source infrastructure as code software tool that
allows managing service life cycle in cloud providers declaratively.
- **Ansible**: Automation tool for configuring and managing computers.

## Installation

### Terraform deployment

Current configuration is hosting a kubernetes cluster on Azure (AKS). We have an
Azure Devops pipeline `apply-terraform.yml` that applies terraform's resources
that are created on our Azure's subscription. The state is then saved to a blob
storage in Azure.

### Kubectl configuration

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

## Documentation

<https://ai-cfia.github.io/howard/en/>
