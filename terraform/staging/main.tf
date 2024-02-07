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
#   source = "./terraform/gcp-kubernetes-cluster"

#   cluster_name = "acia-cfia"
#   project_id   = "spartan-rhino-408115"

#   region     = "northamerica-northeast1"
#   location_1 = "northamerica-northeast1-a"
#   location_2 = "northamerica-northeast1-b"
# }
