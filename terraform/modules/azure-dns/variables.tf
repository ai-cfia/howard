variable "location" {
  description = "The location where the DNS and every resources will be deployed"
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_name" {
  description = "azurerm_dns_zone name"
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "soa_record_tech_contact_email" {
  description = "SOA Record tech contact email"
  type        = string
}
