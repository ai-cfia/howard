resource "azurerm_monitor_workspace" "azure_monitor_workspace" {
  name                = var.name
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  tags = var.tags
}
