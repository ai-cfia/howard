terraform {

  required_version = ">= 1.7.2"

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

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.25"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 3.0"
    # }
  }
}

provider "azurerm" {
  features {}
}

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
  resource_group_name = var.resource_group

  vnet_name   = "vnet-${var.aks_name}"
  subnet_name = "subnet-${var.aks_name}"

  address_space           = [var.virtual_network_address]
  subnet_address_prefixes = [var.subnet_address]
  tags                    = var.tags
}

# module "cluster-network-1" {
#   source                    = "../modules/azure-cluster-network"
#   location                  = var.location_2
#   resource_group_name       = var.resource_group
#   # ..
# }


module "aks-cluster-0" {

  source = "../modules/azure-kubernetes-cluster"

  prefix         = var.aks_name
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  admin_username = var.admin_username

  k8s_version = var.k8s_version

  auto_scaling_default_node = var.auto_scaling_default_node
  zones                     = var.zones
  vm_size                   = var.default_node_vm_size
  max_pods                  = var.max_pods
  node_count                = var.node_count
  node_min_count            = var.node_min_count
  node_max_count            = var.node_max_count

  aks_admin_group_object_ids = var.aks_admin_group_object_ids
  ad_groups                  = var.ad_groups

  network_resource_group = module.cluster-network-0.resource_group_name
  network_vnet           = module.cluster-network-0.virtual_network_name
  network_subnet         = module.cluster-network-0.subnet_name

  service_cidr         = var.service_cidr
  dns_service_ip       = var.dns_service_ip
  pod_cidr             = var.pod_cidr
  docker_bridge_cidr   = var.docker_bridge_cidr
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
