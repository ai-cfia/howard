output "cluster_name" {
  description = "Cluster name to be used in the context of kubectl"
  value       = azurerm_kubernetes_cluster.k8s.name
}
