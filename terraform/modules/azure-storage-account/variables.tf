variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "rg_location" {
  description = "Resource group location"
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "account_tier" {
  description = "Azure storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Azure account replication type"
  type        = string
  default     = "LRS"
}

variable "firewall" {
  description = "List of public IP whitelisted"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

# By using the network_rule block, it is possible to whitelist only the IPs mentioned in the firewall variable
variable "public_network_access_enabled" {
  description = "Azure storage public network access enabled"
  type        = bool
  default     = true
}
