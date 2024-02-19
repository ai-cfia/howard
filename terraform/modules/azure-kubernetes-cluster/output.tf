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
