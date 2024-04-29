variable "vnet_id_1" {
  description = "First virtual network id"
  type        = string
}

variable "vnet_name_1" {
  description = "First network name"
  type        = string
}

variable "rg_vnet_1" {
  description = "Resource group vnet 1"
  type        = string
}

variable "vnet_id_2" {
  description = "Second virtual network id"
  type        = string
}

variable "vnet_name_2" {
  description = "Second network name"
  type        = string
}

variable "rg_vnet_2" {
  description = "Resource group of vnet 2"
  type        = string
}

variable "principal_id_aks_cluster_0" {
  description = "Principal id of cluster 0"
  type = string
}

variable "principal_id_aks_cluster_1" {
  description = "Principal id of cluster 1"
  type = string
}
