resource "azurerm_virtual_network" "vm_virtual_network" {
  name                = var.vm_virtual_network_name
  address_space       = var.vm_virtual_network_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vm_virtual_network_subnet" {
  name                 = var.vm_virtual_network_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vm_virtual_network.name
  address_prefixes     = var.vm_virtual_network_subnet_address_prefixes
}

resource "azurerm_network_interface" "vm_network_interface" {
  name                = var.vm_network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.vm_network_interface_ip_configuration_name
    subnet_id                     = azurerm_subnet.vm_virtual_network_subnet.id
    private_ip_address_allocation = var.vm_network_interface_ip_configuration_type
  }
}
