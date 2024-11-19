terraform {

  backend "azurerm" {
    resource_group_name  = "rg-ai-cfia-terraform-state"
    storage_account_name = "tfcfiastate"
    container_name       = "infra-terraform-state"
    key                  = "tf/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

module "cluster-network-0" {
  source              = "../modules/azure-cluster-network"
  location            = var.location_1
  resource_group_name = azurerm_resource_group.rg.name

  vnet_name   = "vnet-${var.aks_name}"
  subnet_name = "subnet-${var.aks_name}"

  address_space           = [var.virtual_network_address]
  subnet_address_prefixes = [var.subnet_address]
  tags                    = var.tags
}

# module "cluster-network-1" {
#   source              = "../modules/azure-cluster-network"
#   location            = var.location_1
#   resource_group_name = azurerm_resource_group.rg.name

#   vnet_name   = "vnet-${var.aks_gpu_name}"
#   subnet_name = "subnet-${var.aks_gpu_name}"

#   address_space           = [var.second_virtual_network_address]
#   subnet_address_prefixes = [var.second_subnet_address]
#   tags                    = var.tags
# }

# module "peering-cluster-network-0-to-cluster-network-1" {
#   source = "../modules/azure-vnet-peering"

#   depends_on = [module.aks-cluster-0, module.aks-cluster-1]

#   # principal_id_aks_cluster_0 = module.aks-cluster-0.cluster_principal_id
#   # principal_id_aks_cluster_1 = module.aks-cluster-1.cluster_principal_id

#   vnet_id_1   = module.cluster-network-0.virtual_network_id
#   vnet_name_1 = module.cluster-network-0.virtual_network_name
#   rg_vnet_1   = module.cluster-network-0.resource_group_name

#   vnet_id_2   = module.cluster-network-1.virtual_network_id
#   vnet_name_2 = module.cluster-network-1.virtual_network_name
#   rg_vnet_2   = module.cluster-network-1.resource_group_name
# }

module "azure-dns-staging" {
  source = "../modules/azure-dns"

  rg_name = azurerm_resource_group.rg.name

  dns_zone_name     = var.dns_zone_name
  dns_a_record_name = var.dns_a_record_name
  dns_a_records     = var.dns_a_records

  # cluster_kubelet_identity = module.aks-cluster-0.cluster_kubelet_identity

  tags                          = var.tags
  soa_record_tech_contact_email = var.soa_record_tech_contact_email
}

module "aks-cluster-0" {

  depends_on = [module.cluster-network-0]

  source = "../modules/azure-kubernetes-cluster"

  prefix         = var.aks_name
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location

  k8s_version = var.k8s_version

  auto_scaling_default_node = var.auto_scaling_default_node
  zones                     = var.zones
  vm_size                   = var.default_node_vm_size
  max_pods                  = var.max_pods
  node_count                = var.node_count
  node_min_count            = var.node_min_count
  node_max_count            = var.node_max_count

  rbac_enabled               = var.rbac_enabled
  aks_admin_group_object_ids = var.aks_admin_group_object_ids
  # ad_groups                  = var.ad_groups
  # ad_members                 = var.ad_members

  network_resource_group = module.cluster-network-0.resource_group_name
  network_vnet           = module.cluster-network-0.virtual_network_name
  network_subnet         = module.cluster-network-0.subnet_name

  service_cidr         = var.service_cidr
  dns_service_ip       = var.dns_service_ip
  pod_cidr             = var.pod_cidr
  storage_account_name = null

  additional_node_pools = var.additional_node_pools

  tags = var.tags

  sku_tier = var.sku_tier

  # Backup's configuration
  azure_backup_vault_name             = var.azure_backup_vault_name
  azure_backup_datastore_type         = var.azure_backup_datastore_type
  azure_backup_redundancy             = var.azure_backup_redundancy
  azure_backuppolicy_name             = var.azure_backuppolicy_name
  azure_backup_storage_account_name   = var.azure_backup_storage_account_name
  azure_backup_storage_container_name = var.azure_backup_storage_container_name
  azure_backup_trusted_access         = var.azure_backup_trusted_access

  backup_excluded_namespaces     = var.backup_excluded_namespaces
  backup_excluded_resource_types = var.backup_excluded_resource_types
  backup_included_namespaces     = var.backup_included_namespaces
  backup_included_resource_types = var.backup_included_resource_types
  backup_label_selectors         = var.backup_label_selectors
}

# module "aks-cluster-1" {
#   depends_on = [module.cluster-network-1]

#   source = "../modules/azure-kubernetes-cluster"

#   prefix         = var.aks_gpu_name
#   resource_group = azurerm_resource_group.rg.name
#   location       = azurerm_resource_group.rg.location

#   k8s_version = var.k8s_version

#   auto_scaling_default_node = var.auto_scaling_default_node
#   zones                     = var.zones
#   vm_size                   = var.default_gpu_node_vm_size
#   max_pods                  = var.max_pods
#   node_count                = var.gpu_node_count
#   node_min_count            = var.gpu_node_min_count
#   node_max_count            = var.gpu_node_max_count

#   managed                    = var.managed
#   rbac_enabled               = var.rbac_enabled
#   aks_admin_group_object_ids = var.aks_admin_group_object_ids
#   # ad_groups                  = var.ad_groups
#   # ad_members                 = var.ad_members

#   network_resource_group = module.cluster-network-1.resource_group_name
#   network_vnet           = module.cluster-network-1.virtual_network_name
#   network_subnet         = module.cluster-network-1.subnet_name

#   service_cidr         = var.service_cidr
#   dns_service_ip       = var.dns_service_ip
#   pod_cidr             = var.second_pod_cidr
#   storage_account_name = null

#   additional_node_pools = var.additional_node_pools

#   tags = var.tags

#   sku_tier = var.sku_tier
# }

module "vault" {
  source         = "../modules/vault"
  location       = var.location_1
  resource_group = azurerm_resource_group.rg.name
  prefix         = var.environment

  cluster_principal_id    = module.aks-cluster-0.cluster_principal_id
  ca_cluster              = module.aks-cluster-0.cluster_ca_certificate
  kv_identity_resource_id = module.aks-cluster-0.kv_identity_resource_id

  providers = {
    kubernetes = kubernetes
  }
}

module "fertiscan-postgresql-server" {
  source                 = "../modules/azure-postgresql-flexible-server"
  postgresql_server_name = var.postgresql_server_name
  postgresql_rg_location = var.postgresql_rg_location
  postgresql_rg_name     = var.postgresql_rg_name

  postgresql_sku_name       = var.postgresql_sku_name
  postgresql_admin_login    = var.postgresql_admin_login
  postgresql_admin_password = var.postgresql_admin_password

  postgresql_public_network_access_enabled = var.postgresql_public_network_access_enabled
}

# Subnet dedicated to provide internal access From Finesse to protected services from Dev
resource "azurerm_subnet" "subnet_dev" {
  name                 = "subnet-dev"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.cluster-network-0.virtual_network_name
  address_prefixes     = [var.dev_subnet_address]
}

# module "vms" {
#  source = "../modules/azure-vm"
#
#  vm_rg_name  = var.vm_rg_name
#  vm_location = var.vm_location

#  vm_virtual_network_name                    = var.vm_virtual_network_name
#  vm_virtual_network_address_space           = var.vm_virtual_network_address_space
#  vm_virtual_network_subnet_name             = var.vm_virtual_network_subnet_name
#  vm_virtual_network_subnet_address_prefixes = var.vm_virtual_network_subnet_address_prefixes
#  vm_public_ip_name                          = var.vm_public_ip_name
#  vm_public_ip_allocation_method             = var.vm_public_ip_allocation_method

#  bastion_virtual_network_subnet_name             = var.bastion_virtual_network_subnet_name
#  bastion_virtual_network_subnet_address_prefixes = var.bastion_virtual_network_subnet_address_prefixes

#  vm_network_interface_name                  = var.vm_network_interface_name
#  vm_network_interface_ip_configuration_name = var.vm_network_interface_ip_configuration_name
#  vm_network_interface_ip_configuration_type = var.vm_network_interface_ip_configuration_type

#  bastion_public_ip_name              = var.bastion_public_ip_name
#  bastion_public_ip_allocation_method = var.bastion_public_ip_allocation_method
#  bastion_public_ip_sku               = var.bastion_public_ip_sku
#  bastion_host_name                   = var.bastion_host_name
#  bastion_host_ip_configuration_name  = var.bastion_host_ip_configuration_name

#  linux-vms   = var.linux-vms
#  windows-vms = var.windows-vms
# }
