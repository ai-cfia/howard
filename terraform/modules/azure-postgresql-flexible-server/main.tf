resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  name                = var.postgresql_server_name
  resource_group_name = var.postgresql_rg_name
  location            = var.postgresql_rg_location

  version                       = var.postgresql_version
  public_network_access_enabled = var.postgresql_public_network_access_enabled

  backup_retention_days        = var.postgresql_backup_retention_days
  auto_grow_enabled            = var.postgresql_auto_grow
  geo_redundant_backup_enabled = var.postgresql_backup_geo_redundant

  administrator_login    = var.postgresql_admin_login
  administrator_password = var.postgresql_admin_password
  zone                   = var.postgresql_zone

  storage_mb = var.postgresql_storage_mb

  sku_name = var.postgresql_sku_name
}
