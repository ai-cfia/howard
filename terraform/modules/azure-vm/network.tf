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

resource "azurerm_public_ip" "vm_public_ip" {
  name                = var.vm_public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.vm_public_ip_allocation_method
}

resource "azurerm_network_interface" "vm_network_interface" {
  name                = var.vm_network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.vm_network_interface_ip_configuration_name
    subnet_id                     = azurerm_subnet.vm_virtual_network_subnet.id
    private_ip_address_allocation = var.vm_network_interface_ip_configuration_type
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_subnet" "bastion_virtual_network_subnet" {
  name                 = var.bastion_virtual_network_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vm_virtual_network.name
  address_prefixes     = var.bastion_virtual_network_subnet_address_prefixes
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = var.bastion_public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.bastion_public_ip_allocation_method
  sku                 = var.bastion_public_ip_sku
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = var.bastion_host_ip_configuration_name
    subnet_id            = azurerm_subnet.bastion_virtual_network_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}
