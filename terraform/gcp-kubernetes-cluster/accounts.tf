resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_service_account" "kubernetes" {
  account_id = "${var.cluster_name}-kubernetes"
}
