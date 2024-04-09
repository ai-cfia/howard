# Secret management

## Introduction

Secrets are sensitive pieces of information that should be protected from
unauthorized access. In the context of a Kubernetes cluster, secrets are used to
store sensitive data such as passwords, tokens, and keys. To allow for secure
and efficient management of secrets, we are using HashiCorp Vault, a tool that
is designed to manage secrets and protect sensitive data. Vault provides a
centralized way to manage access to secrets and encryption keys, and it also has
the ability to generate dynamic secrets on demand. This document provides an
overview of the secret management process and the role of Vault in securing and
managing secrets in the Kubernetes cluster.

## Vault architecture

Vault is a highly available and distributed system that is designed to provide
secure storage and management of secrets. It is built on a client-server
architecture, with the server being the central component that stores and
manages secrets, and the clients being the applications and services that access
the secrets. The server is responsible for authenticating clients, authorizing
access to secrets, and providing encryption and decryption services. The server
is also responsible for generating dynamic secrets on demand, which are
short-lived and are automatically revoked after a certain period of time.

Current configuration allows vault to inject secrets into pods secrets using the
ArgoCD Vault plugin. The plugin reads placeholders in the YAML files and
replaces them with the actual secret values from Vault. This provides a secure
way to manage secrets in the Kubernetes cluster and ensures that sensitive data
is protected from unauthorized access.

The following diagram illustrates the structure of the Vault architecture within
howard : ![Vault architecture diagram](img/vault-argocd-architecture.svg)

The following sequence diagram describes the process of how a developer can
update secrets using the Vault UI service and how the secrets are injected into
pods :

```mermaid
sequenceDiagram
    participant Developer
    participant FinesseRepo as Finesse Repository
    participant GHWorkflow as GitHub Workflow
    participant ContainerReg as GitHub Container Registry
    participant HowardRepo as Howard Repository
    participant ArgoRepoServer as ArgoCD Repo Server
    participant ArgoVaultPlugin as Argo Vault Plugin
    participant FinessePod as Finesse Pod

    participant VaultUI as Vault UI
    participant Vault as Vault Server

    Developer->>+FinesseRepo: 1. Pushes commits
    FinesseRepo->>+GHWorkflow: Triggers workflow
    GHWorkflow->>+ContainerReg: Builds and pushes new semantic version
    GHWorkflow->>+ArgoRepoServer: Triggers webhook
    ArgoRepoServer->>+FinessePod: Triggers synchronisation to pod
    FinessePod->>+ContainerReg: Fetches image with new version tag
    FinessePod->>+FinessePod: Refreshes deployment with new version
    Developer->>+VaultUI: 2. Accesses UI to update/create secrets
    VaultUI->>+Vault: Commit update/creation of secrets
    Developer->>+HowardRepo: 3. Commits new/updated secrets
    HowardRepo->>+ArgoRepoServer: Triggers sync via webhook
    ArgoRepoServer->>+ArgoVaultPlugin: triggers refresh on finesse namespace,<br> sync secrets from Vault
    ArgoVaultPlugin->>+Vault: Fetch specific version of secrets
    ArgoVaultPlugin->>+FinessePod: Injects secrets
    Developer->>+FinessePod: 4. Trigger hard refresh through argoCD
```

Take note that the developer needs to trigger a hard refresh on the pod to
reflect the changes in the secrets. This is done in the ArgoCD UI, but we
are working on a way to automate this process.

## Secret management process

The secret management process involves the following steps:

1. **Secret creation**: Secrets are created and stored in Vault using the Vault
   CLI or API. When a secret is created, it is encrypted and stored in the
   central Vault server.

2. **Secret retrieval**: Applications and services can retrieve secrets from
    Vault using the Vault CLI or API. When a secret is retrieved, it is
    decrypted and returned to the client in a secure manner.

3. **Dynamic secret generation**: Vault has the ability to generate dynamic
    secrets on demand. This means that instead of storing static secrets in
    Vault, Vault can generate short-lived secrets that are automatically revoked
    after a certain period of time. This provides an additional layer of
    security and reduces the risk of unauthorized access to secrets.

4. **Access control**: Vault provides fine-grained access control to secrets,
    allowing administrators to define policies that specify which clients can
    access which secrets. This ensures that only authorized clients can access
    sensitive data. Currently, we are using the Kubernetes authentication method
    to authenticate hosted applications and authorize access to secrets. As for
    the human users, we are using the Github authentication method to
    authenticate and authorize access to secrets.

## Create, read, update, and delete secrets

Vault provides a UI service to manage secrets. The UI service is a web-based
user interface that allows administrators to create, read, update, and delete
secrets. The service also provides a way to manage access control policies and
audit logs. The service is accessible through a web browser and is protected by
the same security mechanisms as the Vault server.

### Steps to update secrets values using the Vault UI

1. In order to gain access to the Vault UI service, you need to have the
   appropriate permissions and access to the Vault URL. It is currently
   configured to give access to any member of the `ai-cfia` organization on
   Github.
2. Generate a personal access token on Github and use it to authenticate to the
   Vault UI service. The scope of the token should be : ![PAT token
   scope](img/pat-token-scope.png)
3. Gain access to the Vault UI service by navigating to the Vault URL in a web
   browser. You will be prompted to authenticate using your Github PAT token.
4. Once authenticated, you will be able to create, read, update, and delete
   secrets using the UI service. Simply navigate to the PV secret engine and
   follow the path to your applications secrets. The PV secret engine is a
    key-value store that allows you to store and manage secrets for your
    applications. ![PV secret engine](img/pv-secret-engine.png)
5. Once in the directory of your application secrets, simply click on 'create
    new version' and you will be able to add, update, or delete secrets as
    needed. ![Create mew secret](img/create-new-secret.png)

### Steps to update secrets injected into pods

In order to update secrets that are injected into pods, you need to update the
secret manifest for the application. The secret manifest is a YAML file that
defines the secrets that are injected into the pod's as environment variables.
We will use Finesse as an example.

1. Open an issue with the following template : [Secrets update
   template](url to be provided when the template is created). You can then
   create a working branch from the issue.
2. Open `/kubernetes/aks/apps/finesse/base/finesse-secrets.yaml`.
3. Update the secrets key references as needed. For example, to add a new
   secret, you can add a new key-value pair to the `data` section of the secret
  manifest :

```yaml
    FINESSE_BACKEND_AZURE_SEARCH_TRANSFORM_MAP: <FINESSE_BACKEND_AZURE_SEARCH_TRANSFORM_MAP>
```

The key represents the environment variable name that will be injected into the
pod, and the value represents the secret key in Vault that will be used to fetch
the secret value.

Finally, update the version annotation of  the secrets being fetch from vault :

```yaml
# Bump the version of the secret from
avp.kubernetes.io/secret-version: "4"
# To
avp.kubernetes.io/secret-version: "5"
```

This is the new version that we create in step 5 of the previous section.

As additional example, here is an issue and a pull request that showcases the
process of updating secrets in the Nachet application :

- [Issue](https://github.com/ai-cfia/howard/issues/133)
- [Pull request](https://github.com/ai-cfia/howard/pull/131)

## Argo CD Vault plugin (AVP)

The [argocd-vault-plugin](https://argocd-vault-plugin.readthedocs.io/en/stable/)
is used to manage secrets inside our deployments the Gitops way. It allows to
use `<placeholders>` in any YAML or JSON files that have been templated and make
use of annotations to provide the path and version of a secret inside vault.

An example of usage is showcased inside the demo app sample. The official
[documentation](https://argocd-vault-plugin.readthedocs.io/en/stable/howitworks/)
for the plugin is well explained and can be followed according to the usecase
needed.
