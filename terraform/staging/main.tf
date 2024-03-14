terraform {

  backend "azurerm" {
    resource_group_name  = "rg-ai-cfia-terraform-state"
    storage_account_name = "tfcfiastate"
    container_name       = "infra-terraform-state"
    key                  = "tf/terraform.tfstate"
  }

  # backend "gcs" {
  #   bucket = "terraform-tfstate-gcp-storage"
  #   prefix = "terraform/state"
  # }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# provider "google" {
#   project = "spartan-rhino-408115"
#   region  = "northamerica-northeast1"
# }

# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = var.kube_ctx
# }

# module "gcp-kubernetes-cluster-0" {
#   source = "../modules/gcp-kubernetes-cluster"

#   cluster_name = "acia-cfia"
#   project_id   = "spartan-rhino-408115"

#   region     = "northamerica-northeast1"
#   location_1 = "northamerica-northeast1-a"
#   location_2 = "northamerica-northeast1-b"
# }

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
#   source                    = "../modules/azure-cluster-network"
#   location                  = var.location_2
#   resource_group_name       = azurerm_resource_group.rg.name
#   # ..
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

  managed                    = var.managed
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
}

# module "aks-cluster-1" {

#   source = "../modules/azure-kubernetes-cluster"

#   prefix         = var.aks_name
#   resource_group = azurerm_resource_group.rg.name
#   location       = azurerm_resource_group.rg.location_2

# #...
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

module "vms" {
  source = "../modules/azure-vm"

  vm_rg_name  = var.vm_rg_name
  vm_location = var.vm_location

  vm_virtual_network_name                    = var.vm_virtual_network_name
  vm_virtual_network_address_space           = var.vm_virtual_network_address_space
  vm_virtual_network_subnet_name             = var.vm_virtual_network_subnet_name
  vm_virtual_network_subnet_address_prefixes = var.vm_virtual_network_subnet_address_prefixes

  vm_network_interface_name                  = var.vm_network_interface_name
  vm_network_interface_ip_configuration_name = var.vm_network_interface_ip_configuration_name
  vm_network_interface_ip_configuration_type = var.vm_network_interface_ip_configuration_type

  bastion_public_ip_name              = var.bastion_public_ip_name
  bastion_public_ip_allocation_method = var.bastion_public_ip_allocation_method
  bastion_public_ip_sku               = var.bastion_public_ip_sku
  bastion_host_name                   = var.bastion_host_name
  bastion_host_ip_configuration_name  = var.bastion_host_ip_configuration_name

  vms = var.vms
}
