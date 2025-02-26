terraform {

  required_version = ">= 1.7.2"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.7"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
