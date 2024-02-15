locals {
  prefix     = "${var.prefix}-cluster"
  dns_prefix = "${var.prefix}-dns"
  subnet_id  = data.azurerm_subnet.subnet.id
}

data "azurerm_subnet" "subnet" {
  name                 = var.network_subnet
  virtual_network_name = var.network_vnet
  resource_group_name  = var.network_resource_group
}
