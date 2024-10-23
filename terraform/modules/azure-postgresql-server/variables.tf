variable "postgresql_server_name" {
  type = string
}

variable "postgresql_rg_location" {
  type = string
}

variable "postgresql_rg_name" {
  type = string
}

variable "postgresql_sku_name" {
  type = string
}

variable "postgresql_storage_mb" {
  type    = number
  default = 640000
}

variable "postgresql_backup_auto_grow" {
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

variable "postgresql_backup_admin_login" {
  type = string
}

variable "postgresql_backup_admin_password" {
  type = string
}

variable "postgresql_backup_version" {
  type    = string
  default = "11"
}

variable "postgresql_backup_ssl_enforcement_enabled" {
  type    = bool
  default = true
}
