resource "azurerm_role_assignment" "admin" {
  for_each             = toset(var.aks_admin_group_object_ids)
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "namespace-groups" {
  for_each             = toset(var.ad_groups)
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.groups[each.value].id
}

data "azuread_client_config" "current" {}

resource "azuread_group" "groups" {
  display_name     = each.value
  for_each         = toset(var.ad_groups)
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

data "azuread_user" "users" {
  for_each            = toset(var.ad_members)
  user_principal_name = each.value
}

resource "azuread_group_member" "add_members" {
  for_each         = toset(var.ad_groups)
  group_object_id  = azuread_group.groups[each.value].object_id
  member_object_id = data.azuread_user.users[each.value].object_id
}
