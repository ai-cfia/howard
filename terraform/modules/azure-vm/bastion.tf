resource "azurerm_public_ip" "bastion_public_ip" {
  name                = var.bastion_public_ip_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = var.bastion_public_ip_allocation_method
  sku                 = var.bastion_public_ip_sku
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                 = var.bastion_host_ip_configuration_name
    subnet_id            = azurerm_subnet.vm_virtual_network_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}
