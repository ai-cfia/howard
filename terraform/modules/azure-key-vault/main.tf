data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "acia-cfia-dev-azure-key-vault" {
  name                        = var.key_vault_name
  location                    = var.key_vault_resource_group_location
  resource_group_name         = var.key_vault_resource_group_name
  enabled_for_disk_encryption = var.key_vault_enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.key_vault_soft_delete_retention_days
  purge_protection_enabled    = var.key_vault_purge_protection_enabled

  sku_name = var.key_vault_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions     = var.key_vault_key_permissions
    secret_permissions  = var.key_vault_secret_permissions
    storage_permissions = var.key_vault_storage_permissions
  }

  network_acls {
    default_action = var.network_acls_default_action
    bypass         = var.network_acls_bypass

    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
  }
}
