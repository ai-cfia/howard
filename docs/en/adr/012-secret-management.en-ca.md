# ADR-012: Secret Management

## Executive Summary

After thorough analysis of the available options for secret management, we have
decided to adopt HashiCorp Vault. This solution stands out for its strong
integration with Kubernetes, its ability to manage secrets within applications,
its integration with ArgoCD, and its secure method of secret sharing. These
features align Vault with our objectives of agility, security, and efficiency in
managing secrets for our hosted services.

## Context

Secure management of secrets is crucial for the protection of sensitive
information and securing our infrastructure. In our environment, where
Kubernetes plays a central role in managing hosted services, it is essential to
choose a secret management solution that integrates well with this ecosystem,
while offering flexibility and security. Moreover, our use of ArgoCD for
deployment automation requires that our secret management solution integrate
seamlessly, facilitating consistent and secure secret management across our
CI/CD pipelines.

## Decision

We have chosen HashiCorp Vault as our primary solution for secret management.
Vault offers tight integration with Kubernetes, enabling effective secret
management within applications. This integration is demonstrated through the
Vault Kubernetes Auth Method, which allows applications running in Kubernetes to
access secrets stored in Vault using Kubernetes service tokens for
authentication.

Vault also facilitates dynamic rotation of secrets, ensuring that sensitive
information does not remain static and is regularly updated without manual
intervention. This feature is crucial for maintaining a high security posture
and reducing the attack surface related to compromised secrets.

Additionally, Vault can generate on-demand secrets for databases and other
services, reducing the need for storing static secrets and increasing the
efficiency of secret management. Vault's integration with ArgoCD through plugins
such as the Argo CD Vault Plugin simplifies application deployment by ensuring
that necessary secrets are securely injected at the time of deployment.

Choosing a centralized and self-hosted instance of Vault gives complete control
over secret management and ensures compliance with data sovereignty requirements
by allowing us to store and manage secrets within our own infrastructure without
relying on third parties.

Adopting Vault also facilitates the implementation of GitOps practices for
configuration and secret management, ensuring that all changes are traceable,
auditable, and deployed through continuous integration and deployment processes.

## Considered Alternatives

### Azure Key Vault

Advantages:

- Native integration with the Azure ecosystem, facilitating secret management
  for Azure resources.

Disadvantages:

- Primarily limited to the Azure ecosystem, presenting challenges for
  multi-cloud or hybrid deployments.

- Less native integration with Kubernetes compared to HashiCorp Vault, which
  could complicate secret management in our Kubernetes applications.

- Azure Key Vault cannot be self-hosted, which may pose data sovereignty and
  compliance issues.

- The GitHub action for Azure Key Vault is obsolete and no longer maintained.
  The only way to retrieve secrets from Azure Key Vault in a pipeline is by
  using a custom script. This is explained in their archived repository.

- Azure Key Vault does not support secret versioning and does not allow for
  GitOps management of secrets.

### Mozilla SOPS

Advantages:

- SOPS is a secret management tool that encrypts/decrypts file content with a
  key derived from AWS, KMS, GCP KMS, Azure Key Vault, or PGP, ensuring that
  secrets are always encrypted and can be easily integrated into version control
  systems.

Disadvantages:

- SOPS is not a secret management solution that fulfills all our needs
  autonomously. It does not manage the storage of secrets in a centralized
  location or the rotation of secrets.

## Consequences

The adoption of HashiCorp Vault will enable us to enhance the security of our
infrastructure by centralizing secret management in a tool specifically designed
for this purpose. Integration with Kubernetes and ArgoCD supports our automation
and efficiency efforts, ensuring that secrets are managed and deployed securely
in our environment. This decision will require training our teams on Vault and
adjusting our existing processes to fully integrate Vault into our CI/CD
pipeline.

## References

- [Documentation on our configuration and use of HashiCorp
  Vault](https://github.com/ai-cfia/howard/blob/main/docs/secrets-management.md)
- [Official HashiCorp Vault
  Documentation](https://developer.hashicorp.com/vault/docs?product_intent=vault)
- [HashiCorp Vault integration with
  Kubernetes](https://www.vaultproject.io/use-cases/kubernetes)
- [Guide on HashiCorp Vault integration with
  ArgoCD](https://github.com/argoproj-labs/argocd-vault-plugin)
- [Vault-action for integrating Vault into our CI/CD
  pipelines](https://github.com/hashicorp/vault-action)
- [Azure Key Vault
  Overview](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
- [Mozilla SOPS Repository](https://github.com/getsops/sops)
- [Obsolete Azure key vault
  action](https://github.com/Azure/get-keyvault-secrets)
