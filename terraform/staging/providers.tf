terraform {

  required_version = ">= 1.7.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.15"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
