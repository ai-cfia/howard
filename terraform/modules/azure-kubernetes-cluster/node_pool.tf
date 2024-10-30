resource "azurerm_kubernetes_cluster_node_pool" "aks" {

  for_each = var.additional_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vnet_subnet_id        = local.subnet_id
  name                  = substr(each.key, 0, 12)
  vm_size               = each.value.vm_size
  os_disk_size_gb       = each.value.os_disk_size_gb
  auto_scaling_enabled  = each.value.enable_auto_scaling
  zones                 = each.value.zones
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  max_pods              = each.value.max_pods
  node_labels           = each.value.node_labels
  node_taints           = each.value.taints
}
