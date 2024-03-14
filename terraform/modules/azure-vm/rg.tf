resource "azurerm_resource_group" "rg" {
  name     = var.vm_rg_name
  location = var.vm_location
}
