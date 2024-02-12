output "cluster_name" {
  description = "Cluster name to be used in the context of kubectl"
  value       = azurerm_kubernetes_cluster.k8s.name
}

# output "kube_config_raw" {
#   description = "Client configuration file for connecting to the cluster"
#   value       = azurerm_kubernetes_cluster.k8s.kube_config_raw
#   sensitive   = true
# }

# output "kube_config_file" {
#   description = "Kubeconfig file"
#   value       = local_file.kubeconfig_file.filename
# }

# output "config" {
#   description = "Commands to configure kubectl local"
#   value       = <<EOF
# Run the following commands to configure kubectl local:
# $ terraform output kube_config_raw > ~/.kube/aksconfig
# $ export KUBECONFIG=~/.kube/aksconfig
# EOF

# }
