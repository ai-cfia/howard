terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-gcp-storage"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.24.0"
    }
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 3.0"
    # }
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 2.0"
    # }
  }
}

provider "google" {
  project = "spartan-rhino-408115"
  region  = "northamerica-northeast1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.kube_ctx
}