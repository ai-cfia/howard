resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location_1
  tags     = var.tags
}
