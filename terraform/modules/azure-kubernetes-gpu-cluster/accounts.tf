resource "azurerm_user_assigned_identity" "example_identity" {
  resource_group_name = var.resource_group
  location            = var.location
  name                = "${local.prefix}-identity"
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/routeTables/%s", var.subscription_id, var.route_table_resource_group_name, var.route_table_name)
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s-gpu.identity[0].principal_id
}
