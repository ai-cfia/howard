output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "resource_group_name" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}
