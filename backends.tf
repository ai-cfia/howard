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
  }
}