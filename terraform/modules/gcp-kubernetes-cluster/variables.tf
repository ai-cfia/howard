variable "region" {
  description = "The region where the cluster and every resources will be deployed"
  type        = string
}

variable "project_id" {
  description = "The project id where this terraform module will be deployed."
  type        = string
}

variable "location_1" {
  description = "The location where the cluster and every resources will be deployed"
  type        = string
}

variable "location_2" {
  description = "The location where the cluster and every resources will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name. Every resources will have this name (exemple: mycluster-compute-network) "
  type        = string
}
