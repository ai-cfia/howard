resource "azurerm_kubernetes_cluster" "k8s" {

  name                    = local.prefix
  resource_group_name     = var.resource_group
  location                = var.location
  dns_prefix              = local.dns_prefix
  kubernetes_version      = var.k8s_version
  private_cluster_enabled = var.k8s_private_cluster_enabled

  default_node_pool {
    name                 = "main"
    vm_size              = var.vm_size
    vnet_subnet_id       = local.subnet_id
    auto_scaling_enabled = var.auto_scaling_default_node
    zones                = var.zones
    node_count           = var.node_count
    min_count            = var.node_min_count
    max_count            = var.node_max_count
    max_pods             = var.max_pods
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled     = var.rbac_enabled

  }

  identity {
    type         = var.identity_type
    identity_ids = var.user_assigned_identity_ids
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  network_profile {
    network_plugin = "kubenet"
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
    pod_cidr       = var.pod_cidr
  }

  lifecycle {
    ignore_changes = [
      default_node_pool
    ]
  }

  automatic_upgrade_channel = var.automatic_upgrade_channel

  # service_mesh_profile {
  #   mode = var.aks_service_mesh_profile
  # }

  tags = var.tags

  sku_tier = var.sku_tier
}
