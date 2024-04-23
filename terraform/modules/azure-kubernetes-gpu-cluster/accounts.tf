resource "azurerm_user_assigned_identity" "example_identity" {
  resource_group_name = var.resource_group
  location            = var.location
  name                = "${local.prefix}-identity"
}
