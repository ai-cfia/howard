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

variable "dns_mx_record_name" {
  description = "DNS MX Record name (@) to specify non-email server"
  type        = string
  default     = "@"
}

variable "dns_txt_record_name_spf" {
  description = "DNS TXT Record name (@) for SPF to specify non-email server"
  type        = string
  default     = "@"
}

variable "dns_txt_record_name_dkim" {
  description = "DNS TXT Record name (@) for DKIM to specify non-email server"
  type        = string
  default     = "*._domainkey"
}

variable "dns_txt_record_name_dmarc" {
  description = "DNS TXT Record name (@) for DMARC to specify non-email server"
  type        = string
  default     = "_dmarc"
}
