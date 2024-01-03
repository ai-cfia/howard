module "gcp-kubernetes-cluster-0" {
  source = "./terraform/gcp-kubernetes-cluster"

  cluster_name = "acia-cfia"
  project_id   = "spartan-rhino-408115"

  region     = "northamerica-northeast1"
  location_1 = "northamerica-northeast1-a"
  location_2 = "northamerica-northeast1-b"
}

# module "namecheap" {
#   source = "./terraform/dns"

#   cluster_name = "acia-cfia"
#   project_id   = "spartan-rhino-408115"

#   region     = "northamerica-northeast1"
#   location_1 = "northamerica-northeast1-a"
#   location_2 = "northamerica-northeast1-b"
# }
