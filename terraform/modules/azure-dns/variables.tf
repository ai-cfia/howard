variable "region" {
  description = "The region where the DNS and every resources will be deployed"
  type        = string
}

variable "rg-name" {
  description = "Azure resource group containing the dns_zone"
  type        = string
}

variable "dns-zone-name" {
  description = "azurerm_dns_zone name"
  type        = string
}

variable "created-by" {
  description = "tags: created-by"
  type        = string
}

variable "tech-contact" {
  description = "tags: tech-contact"
  type        = string
}
variable "environment" {
  description = "tags: environment"
  type        = string
}
