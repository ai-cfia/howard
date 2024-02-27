variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_zone_name" {
  description = "azurerm_dns_zone name"
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "soa_record_tech_contact_email" {
  description = "SOA Record tech contact email (no @ inside the email)"
  type        = string
}

variable "dns_a_record_name" {
  description = "DNS A Record name (@)"
  type        = string
}

variable "dns_a_records" {
  description = "DNS A records list"
  type        = list(string)
}

# variable "cluster_kubelet_identity" {
#   description = "Kubernetes (AKS) cluster kubelet identity"
#   type        = string
# }
