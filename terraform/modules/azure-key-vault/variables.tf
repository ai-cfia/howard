variable "key_vault_name" {
  description = "Azure key vault name"
  type        = string
}

variable "key_vault_resource_group_name" {
  description = "Azure key vault resource group name"
  type        = string
}

variable "key_vault_resource_group_location" {
  description = "Azure key vault resource group location"
  type        = string
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Enable key vault disk encryption"
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "Azure key vault soft delete rentetion days"
  type        = number
  default     = 7
}

variable "key_vault_purge_protection_enabled" {
  description = "Azure key vault purge protection enabled"
  type        = bool
  default     = false
}

variable "key_vault_sku_name" {
  description = "Azure key vault sku name"
  type        = string
  default     = "standard"
}

variable "key_vault_key_permissions" {
  description = "Azure key vault key permissions"
  type        = list(string)
}

variable "key_vault_secret_permissions" {
  description = "Azure key vault secret permissions"
  type        = list(string)
}

variable "key_vault_storage_permissions" {
  description = "Azure key vault storage permissions"
  type        = list(string)
}

variable "network_acls_default_action" {
  description = "Network acls default action"
  type        = string
  default     = "Deny"
}

variable "network_acls_bypass" {
  description = "Network acls bypass"
  type        = string
  default     = "AzureServices"
}

variable "network_acls_ip_rules" {
  description = "Network acls ip rules"
  type        = list(string)
}

variable "network_acls_virtual_network_subnet_ids" {
  description = "Network acls virtual network subnet ids"
  type        = list(string)
}
