data "azurerm_client_config" "current" {}

# Needed to provide unique vault name
resource "random_string" "azurerm_key_vault_name" {
  length  = 5
  numeric = true
  special = false
  upper   = false
}

locals {
  suffix = random_string.azurerm_key_vault_name.result
}

# Create Azure Key Vault
resource "azurerm_key_vault" "vault" {
  name                       = "${var.prefix}-vault-${local.suffix}"
  location                   = var.location
  resource_group_name        = var.resource_group
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions         = var.key_permissions
    secret_permissions      = var.secret_permissions
    certificate_permissions = var.certificate_permissions
  }

  // Additional access policy for the AKS managed identity
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.kv_identity_resource_id

    key_permissions         = var.key_permissions
    secret_permissions      = var.secret_permissions
    certificate_permissions = var.certificate_permissions
  }
}

resource "azurerm_key_vault_key" "vault_unseal" {
  name         = "${var.prefix}-vault-unseal-${local.suffix}"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = var.key_opts

  # Define the rotation policy
  rotation_policy {
    automatic {
      time_before_expiry = "P7D"
    }

    expire_after         = "P28D"
    notify_before_expiry = "P7D"
  }
}

# Set an access policy for the service principal to the Key Vault
resource "azurerm_key_vault_access_policy" "vault" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.cluster_principal_id

  key_permissions         = var.aks_key_permissions
  secret_permissions      = var.aks_secret_permissions
  certificate_permissions = var.certificate_permissions

}

# We make ask Kubernetes to sign the certificate
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
resource "kubernetes_certificate_signing_request_v1" "vault_kube_cert_req" {
  metadata {
    name = "vault.svc"
  }
  spec {
    request     = data.external.k8s_cert_request.result["request"]
    signer_name = "kubernetes.io/kubelet-serving"
    usages      = ["digital signature", "key encipherment", "server auth"]
  }
  auto_approve = true
  lifecycle {
    ignore_changes       = [spec[0].request]
    replace_triggered_by = [tls_private_key.pair]
  }
}

# Makes sure the vault namespace is created before adding secrets
resource "kubernetes_namespace" "vault_ns" {
  metadata {
    name = "vault"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "kubernetes_secret" "vault_ha_tls" {
  metadata {
    name      = "vault-ha-tls"
    namespace = kubernetes_namespace.vault_ns.metadata[0].name
  }

  data = {
    "vault.crt" = kubernetes_certificate_signing_request_v1.vault_kube_cert_req.certificate
    "vault.key" = tls_private_key.pair.private_key_pem
    "vault.ca"  = base64decode(var.ca_cluster)
  }

  type = "kubernetes.io/generic"
}
