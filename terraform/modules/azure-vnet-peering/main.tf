resource "azurerm_virtual_network_peering" "peering_vnet1_to_vnet2" {
  name                         = "peering-${var.vnet_name_1}-to-${var.vnet_name_2}"
  resource_group_name          = var.rg_vnet_1
  virtual_network_name         = var.vnet_name_1
  remote_virtual_network_id    = var.vnet_id_2
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peering_vnet2_to_vnet1" {
  name                         = "peering-${var.vnet_name_2}-to-${var.vnet_name_1}"
  resource_group_name          = var.rg_vnet_2
  virtual_network_name         = var.vnet_name_2
  remote_virtual_network_id    = var.vnet_id_1
  allow_virtual_network_access = true
}

resource "azurerm_role_assignment" "aks_one_network_contributor" {
  principal_id         = var.principal_id_aks_cluster_0
  role_definition_name = "Network Contributor"
  scope                = var.vnet_id_1
  depends_on           = [azurerm_virtual_network_peering.peering_vnet1_to_vnet2]
}

resource "azurerm_role_assignment" "aks_two_network_contributor" {
  principal_id         = var.principal_id_aks_cluster_1
  role_definition_name = "Network Contributor"
  scope                = var.vnet_id_2
  depends_on           = [azurerm_virtual_network_peering.peering_vnet2_to_vnet1]
}
