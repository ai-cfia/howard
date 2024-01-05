resource "google_container_cluster" "cluster" {
  name                     = "${var.cluster_name}-cluster"
  location                 = var.location_1
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.network.self_link
  subnetwork               = google_compute_subnetwork.subnetwork.self_link
  networking_mode          = "VPC_NATIVE"
  deletion_protection      = false
  # logging_service          = "logging.googleapis.com/kubernetes"
  # monitoring_service       = "monitoring.googleapis.com/kubernetes"

  # Optional, if you want multi-zonal cluster
  node_locations = [
    "${var.location_2}"
  ]

  addons_config {
    http_load_balancing {
      disabled = true # NGINX Ingress
    }

    horizontal_pod_autoscaling {
      disabled = false # Self-managed
    }
  }

  release_channel {
    channel = "RAPID"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.cluster_name}-pod-range"
    services_secondary_range_name = "${var.cluster_name}-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Enable Kubernetes Gateway API
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
}

resource "google_container_node_pool" "nodepool" {
  name       = "${var.cluster_name}-standard-nodepool"
  cluster    = google_container_cluster.cluster.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}