resource "azurerm_storage_account" "azure_storage_account" {
  name                = var.azure_storage_account_name
  resource_group_name = var.rg_name

  location                 = var.rg_location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  public_network_access_enabled = var.public_network_access_enabled

  network_rules {
    default_action = "Deny"
    ip_rules       = var.firewall
  }

  tags = var.tags
}
