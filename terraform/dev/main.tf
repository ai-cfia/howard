terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ai-cfia-terraform-state"
    storage_account_name = "tfcfiastatedev"
    container_name       = "infra-terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# module "azure-dns-staging" {
#   source = "../modules/azure-dns"
#   rg_name = azurerm_resource_group.rg.name
#   dns_zone_name     = var.dns_zone_name
#   dns_a_record_name = var.dns_a_record_name
#   dns_a_records     = var.dns_a_records
#   # cluster_kubelet_identity = module.aks-cluster-0.cluster_kubelet_identity
#   tags                          = var.tags
#   soa_record_tech_contact_email = var.soa_record_tech_contact_email
# }

module "aks-cluster-0" {
  source                     = "../modules/azure-kubernetes-cluster"
  prefix                     = var.aks_name
  resource_group             = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  k8s_version                = var.k8s_version
  auto_scaling_default_node  = var.auto_scaling_default_node
  zones                      = var.zones
  vm_size                    = var.default_node_vm_size
  max_pods                   = var.max_pods
  node_count                 = var.node_count
  node_min_count             = var.node_min_count
  node_max_count             = var.node_max_count
  managed                    = var.managed
  rbac_enabled               = var.rbac_enabled
  aks_admin_group_object_ids = var.aks_admin_group_object_ids
  # ad_groups                  = var.ad_groups
  # ad_members                 = var.ad_members
  network_resource_group = var.vnet-network-name
  network_vnet           = var.vnet-network-address-space
  network_subnet         = var.vnet-network-subnet-name
  service_cidr           = var.service_cidr
  dns_service_ip         = var.dns_service_ip
  pod_cidr               = var.pod_cidr
  storage_account_name   = null
  additional_node_pools  = var.additional_node_pools
  tags                   = var.tags
  sku_tier               = var.sku_tier
}

module "vault" {
  source                  = "../modules/vault"
  location                = var.location_1
  resource_group          = azurerm_resource_group.rg.name
  prefix                  = var.environment
  cluster_principal_id    = module.aks-cluster-0.cluster_principal_id
  ca_cluster              = module.aks-cluster-0.cluster_ca_certificate
  kv_identity_resource_id = module.aks-cluster-0.kv_identity_resource_id
  providers = {
    kubernetes = kubernetes
  }
}

# Subnet dedicated to provide internal access From Finesse to protected services from Dev
# resource "azurerm_subnet" "subnet_dev" {
#   name                 = "subnet-dev"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = var.vnet-private-network-name
#   address_prefixes     = [var.vnet-private-network-subnet]
# }
