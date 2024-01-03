terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}