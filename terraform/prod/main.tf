# terraform {

#   required_version = ">= 1.1.0"

#   backend "azurerm" {
#     resource_group_name  = "rg-ai-cfia-terraform-state"
#     storage_account_name = "tfcfiastate"
#     container_name       = "infra-terraform-state"
#     key                  = "tf/terraform.tfstate"
#   }

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.25"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "2.24.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }
