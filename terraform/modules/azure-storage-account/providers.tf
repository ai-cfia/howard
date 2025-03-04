terraform {

  required_version = ">= 1.7.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.7"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}
