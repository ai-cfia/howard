resource "azurerm_postgresql_server" "postgresql_server" {
  name                = var.postgresql_server_name
  location            = var.postgresql_rg_location
  resource_group_name = var.postgresql_rg_name

  sku_name = var.postgresql_sku_name

  storage_mb                   = var.postgresql_storage_mb
  backup_retention_days        = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_backup_geo_redundant
  auto_grow_enabled            = var.postgresql_backup_auto_grow

  administrator_login          = var.postgresql_backup_admin_login
  administrator_login_password = var.postgresql_backup_admin_password
  version                      = var.postgresql_backup_version
  ssl_enforcement_enabled      = var.postgresql_backup_ssl_enforcement_enabled
}
