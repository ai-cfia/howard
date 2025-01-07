data "azuread_user" "users" {
  for_each            = { for email in var.user_emails : email => email }
  user_principal_name = each.value
}

resource "azurerm_role_definition" "custom_role" {
  name        = "tf_default_ai_cfia_az_role"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Gives read access on resourceGroups, resources, resourcegroups/deployments, resourcegroups/deployments/operations and resourcegroups/resources"

  permissions {
    actions     = var.role_actions
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azurerm_role_assignment" "role_assignments" {
  for_each             = data.azuread_user.users
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.custom_role.name
  principal_id         = each.value.id
}
