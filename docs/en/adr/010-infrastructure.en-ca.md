# ADR-010: Infrastructure

## Executive Summary

In an effort to optimize and secure our infrastructure operations, our
organization has adopted a strategy based on Infrastructure as Code (IaC) using
Terraform, complemented by the deployment of a Kubernetes cluster on Azure. This
approach allows us to overcome the limitations associated with traditional
methods such as ClickOps and manual deployments, which were both time-consuming
and error-prone. The adoption of HashiCorp Vault for centralized secret
management and ArgoCD for deployment orchestration strengthens our security and
agility posture. By integrating advanced monitoring solutions and considering
the use of technologies like OpenTelemetry for enhanced observability, we aim to
maintain high availability and performance of our services. This transformation
allows for more robust and automated infrastructure management, reduces the
risks of human error, and provides increased flexibility and portability across
different cloud environments. Our initiative aligns infrastructure management
with our operational goals while ensuring enhanced scalability and security to
meet future needs.

## Context

Our team faces challenges in deploying solutions, especially in choosing cloud
providers. Initially, we used [Google Cloud
Run](https://cloud.google.com/run/?hl=en) and [Azure App
Service](https://azure.microsoft.com/en-ca/products/app-service/). However, due
to the absence of a Google Cloud account and access restrictions on Azure, we
find ourselves switching from one account to another, resulting in significant
downtime for our applications.

Moreover, the manual creation of all services on cloud providers via ClickOps
proved tedious. To overcome this challenge, we decided to adopt Infrastructure
as Code (IaC) using Terraform. This approach allows us to manage and provision
our cloud infrastructures via codified configuration files, thus eliminating the
need for ClickOps and significantly reducing human errors.

Regarding security, we initially adopted [Azure Key
Vault](https://azure.microsoft.com/en-us/products/key-vault/) for the manual
retrieval of environment variable values. However, recognizing the need for a
more robust and versatile solution for secret management, we have evolved
towards maintaining a HashiCorp Vault instance. This transition enables
centralized management of secrets and credentials across different environments
and platforms.

Currently, scaling our applications is not a priority, as we have a fixed
visibility on the number of users. However, we have not yet implemented a
scaling solution.

For monitoring and telemetry, we currently rely exclusively on the built-in
tools of cloud providers, such as those from Google Cloud Run. However, it is
important to consider the flexibility and portability that external services
such as [OpenTelemetry](https://opentelemetry.io/) can offer. These solutions
can not only adapt to various cloud environments but also provide custom
customization specifically tailored to our needs. Although in-house solutions
may seem demanding in terms of maintenance, they allow us to optimize our
monitoring and telemetry in a targeted way, thus offering a more precise
alignment with our operational goals.

In short, many tasks are currently performed manually. Although we have a Github
Workflow for deploying Docker images, the management of deployments across
different cloud providers is not automated. In the event of a production error,
no solution allows developers to quickly resolve the issue.

## Use Cases

- Manage PostgreSQL database (and soon PostgreSQL ML) without resorting to
  ClickOps.
- Increase data redundancy more effectively.
- Deploy, manage, monitor, and instrument applications within the organization.
- Improve secret management.
- Eliminate silos between the security team and the DevOps team within the
  organization.
- Implement deployments across all cloud providers in case of outages. This
  includes data persistence across different cloud providers.
- Manage a centralized SSO solution to authenticate users of hosted services.
- Use Infrastructure as Code to automate the creation, deployment, and
  management of infrastructure, enabling faster infrastructure operations while
  reducing manual errors.
- Automate scaling (HPA).
- Adopt a backup and disaster recovery strategy.
- Create documentation that is easy to read and adapt to enable a "shift-left"
  transition (Early and thorough integration of testing, security, and quality
  assurance at the beginning of the software development cycle, for earlier
  identification and resolution of anomalies).
- Avoid single points of failure.

## Decision

Our solution will consist of deploying Kubernetes clusters on various cloud
providers. Here are the components that will be deployed to manage various use
cases:

- [Container management and deployment: Kubernetes](014-containers.fr-ca.md)
- [Secret management: HashiCorp Vault](012-secret-management.fr-ca.md)
- [Deployment management: ArgoCD](011-gitops.fr-ca.md)
- [Infrastructure as Code (IaC) management: Terraform](013-IaC-tool.fr-ca.md)
- Development environment management: AzureML (coming soon)
- [User authentication management:
  Vouch-proxy](015-authentication-management.fr-ca.md)
- Observability management: Grafana, Prometheus, Open-Telemetry, and OneUptime
  (coming soon)
- [Load balancing management: Ingress NGINX](016-networking.fr-ca.md)
- [Security management: Trivy and Falco](017-security.fr-ca.md)
- Managing redundancy: Itsio / Cluster mesh (coming soon)

Additional components will be added as needed.

## Consequences

The transition to Kubernetes-based infrastructure management and Terraform,
combined with the use of robust solutions for secret management (HashiCorp
Vault) and deployment (ArgoCD), marks significant progress towards full
automation and increased security of our cloud environment.

This approach minimizes manual interventions and error risks while enhancing
security at every stage of application deployment. Using open-source tools
promotes greater transparency, adaptability to multiple environments, and easier
integration with various ecosystems. Furthermore, adopting GitOps practices,
notably through Terraform and ArgoCD, improves the traceability and
reversibility of changes made to the infrastructure, essential for configuration
management and security compliance. These changes support our ability to scale
quickly and reliably while maintaining strict control over data security and
user authentication through Vouch-proxy and integrating solutions such as NGINX
Ingress for access management. However, this evolution requires ongoing skill
development of our teams and sustained attention to updates and maintenance of
these technologies to ensure their effectiveness and security over the long
term.

## References

- [Howard Repository - Contains the configuration of our infrastructure along
  with documentation](https://github.com/ai-cfia/howard)
