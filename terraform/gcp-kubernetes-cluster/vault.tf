# Create a service account for the Vault KMS
resource "google_service_account" "vault_kms_service_account" {
  account_id   = "${var.cluster_name}-vault-gcpkms"
  display_name = "Vault KMS for auto-unseal"
}

# This will be used to create a credentials.json inside a k8s secret obj
resource "google_service_account_key" "vault_kms_service_account_key" {
  service_account_id = google_service_account.vault_kms_service_account.name
}

# Create a KMS Key
resource "google_kms_key_ring" "key_ring" {
  name     = "vault-keyring-gcp"
  location = var.region
}

# Create a crypto key for the key ring. This key will be used to automatically unseal Vault
resource "google_kms_crypto_key" "crypto_key" {
  name            = "vault-cryptokey-gcp"
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "100000s"
}

# We give vault service account access to that key ring. Making im owner of the key.
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role        = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault_kms_service_account.email}",
  ]
}

# Vault certificates
resource "tls_private_key" "vault_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# This requires that jq and openssl are installed in the runtime environment
# It creates a certificate signing request (CSR) based on the vault-csr.conf file
# The 2 jq at the begining and end of the pipes are used to read the input and wrap the result in json
# since this is how terraform "external" passes data.
data "external" "k8s_cert_request" {
  program = [
    "bash", "-c",
    "curl -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x jq && jq -rc '.key' | openssl req -new -noenc -config ${path.module}/vault-csr.conf -key /dev/stdin | jq -rRncs '{\"request\": inputs}'"
  ]
  query = {
    "key" = tls_private_key.vault_key.private_key_pem
  }
}

# We make ask Kubernetes to sign the certificate
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
resource "kubernetes_certificate_signing_request_v1" "vault_kube_cert_req" {
  metadata {
    name = "vault.svc"
  }
  spec {
    request     = data.external.k8s_cert_request.result["request"]
    signer_name = "kubernetes.io/kube-apiserver-client"
    usages      = ["digital signature", "key encipherment", "server auth"]
  }
  auto_approve = true
  lifecycle {
    ignore_changes       = [spec[0].request]
    replace_triggered_by = [tls_private_key.vault_key]
  }
}

# Makes sure the vault namespace is created before adding secrets
resource "kubernetes_namespace" "vault_ns" {
  metadata {
    name = "vault"
  }
}

# Get the GKE cluster data to fetch the CA certificate
data "google_container_cluster" "gke_cluster" {
  name     = "${var.cluster_name}-cluster"
  location = "${var.region}-a"
}

# This secret contains the certificates used 
resource "kubernetes_secret" "vault_ha_tls" {
  metadata {
    name      = "vault-ha-tls"
    namespace = kubernetes_namespace.vault_ns.metadata[0].name
  }

  data = {
    "vault.key" = tls_private_key.vault_key.private_key_pem
    "vault.crt" = kubernetes_certificate_signing_request_v1.vault_kube_cert_req.certificate
    "vault.ca"  = base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
  }

  type = "kubernetes.io/generic"
}

# This secret contains the GCP KMS service account that is used to unseal
resource "kubernetes_secret" "kms_creds" {
  metadata {
    name      = "kms-creds"
    namespace = kubernetes_namespace.vault_ns.metadata[0].name
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.vault_kms_service_account_key.private_key)
  }

  type = "kubernetes.io/generic"
}
