variable "postgresql_server_name" {
  type = string
}

variable "postgresql_rg_location" {
  type = string
}

variable "postgresql_rg_name" {
  type = string
}

variable "postgresql_zone" {
  type    = string
  default = "1"
}

variable "postgresql_sku_name" {
  type = string
}

variable "postgresql_storage_mb" {
  type    = number
  default = 640000
}

variable "postgresql_auto_grow" {
  type    = bool
  default = false
}

variable "postgresql_backup_retention_days" {
  type    = number
  default = 7
}

variable "postgresql_backup_geo_redundant" {
  type    = bool
  default = false
}

variable "postgresql_admin_login" {
  type = string
}

variable "postgresql_admin_password" {
  type = string
}

variable "postgresql_version" {
  type    = string
  default = "12"
}

variable "postgresql_public_network_access_enabled" {
  type = bool
}
