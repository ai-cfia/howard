output "cluster_name" {
  description = "Cluster name to be used in the context of kubectl"
  value       = azurerm_kubernetes_cluster.k8s.name
}

output "cluster_ca_certificate" {
  description = "Cluster certificate"
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
}

output "cluster_principal_id" {
  description = "AKS cluster principal id"
  value       = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}

output "kv_identity_resource_id" {
  description = "The client ID of the managed identity used by the Azure Key Vault Secrets Provider"
  value       = azurerm_kubernetes_cluster.k8s.key_vault_secrets_provider[0].secret_identity[0].object_id
}

#output "cluster_kubelet_identity" {
#  description = "Kubelet identity object ID"
#  value       = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].client_id
#}
