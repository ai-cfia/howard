terraform {

  required_version = ">= 1.7.2"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
