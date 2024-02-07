resource "google_compute_network" "network" {
  name                            = "${var.cluster_name}-network"
  routing_mode                    = "REGIONAL" # global
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "subnetwork" {
  name                     = "${var.cluster_name}-private-subnet"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.region
  network                  = google_compute_network.network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.cluster_name}-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "${var.cluster_name}-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.cluster_name}-router"
  region  = var.region
  network = google_compute_network.network.id
}

resource "google_compute_router_nat" "router-nat" {
  name   = "${var.cluster_name}-nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.subnetwork.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

resource "google_compute_address" "nat" {
  name         = "${var.cluster_name}-nat"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"

  depends_on = [google_project_service.compute]
}

# Enable SSH
# resource "google_compute_firewall" "allow-ssh" {
#   name    = "${var.cluster_name}-allow-ssh"
#   network = google_compute_network.network.name

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }
