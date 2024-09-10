# For more information see: https://learn.microsoft.com/en-us/azure/backup/quick-kubernetes-backup-terraform

data "azurerm_client_config" "current" {
}

#Create a Backup Vault
resource "azurerm_data_protection_backup_vault" "aks-backup-vault" {
  name                = var.azure_backup_vault_name
  resource_group_name = var.resource_group
  location            = var.location
  datastore_type      = var.azure_backup_datastore_type
  redundancy          = var.azure_backup_redundancy

  identity {
    type = "SystemAssigned" # only possible value, see: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault
  }

  depends_on = [azurerm_kubernetes_cluster.k8s]
}

# Create a Backup Policy with 1 days backup and 2 day retention duration (backups are at 18:00 EST)
resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "policy" {
  name                = var.azure_backuppolicy_name
  resource_group_name = var.resource_group
  vault_name          = var.azure_backup_vault_name

  backup_repeating_time_intervals = ["R/2024-04-14T23:00:00Z/P1D"]

  default_retention_rule {
    life_cycle {
      duration        = "P2D"
      data_store_type = "OperationalStore"
    }
  }

  depends_on = [azurerm_data_protection_backup_vault.aks-backup-vault]
}

# Create a Trusted Access Role Binding between AKS Cluster and Backup Vault
resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "trustedaccess" {
  name                  = var.azure_backup_trusted_access
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = azurerm_data_protection_backup_vault.aks-backup-vault.id
  depends_on            = [azurerm_data_protection_backup_vault.aks-backup-vault, azurerm_kubernetes_cluster.k8s]
}

# Create a Backup Storage Account provided in input for Backup Extension Installation
resource "azurerm_storage_account" "backupsa" {
  name                     = var.azure_backup_storage_account_name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_kubernetes_cluster_trusted_access_role_binding.trustedaccess]
}

# Create a Blob Container where backup items will stored
resource "azurerm_storage_container" "backupcontainer" {
  name                  = var.azure_backup_storage_container_name
  storage_account_name  = azurerm_storage_account.backupsa.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.backupsa]
}

# Create Backup Extension in AKS Cluster
resource "azurerm_kubernetes_cluster_extension" "dataprotection" {
  name           = "${local.prefix}-cluster-backup-extension"
  cluster_id     = azurerm_kubernetes_cluster.k8s.id
  extension_type = var.azure_backup_extension_type
  configuration_settings = {
    "configuration.backupStorageLocation.bucket"                = azurerm_storage_container.backupcontainer.name
    "configuration.backupStorageLocation.config.storageAccount" = azurerm_storage_account.backupsa.name
    "configuration.backupStorageLocation.config.resourceGroup"  = azurerm_storage_account.backupsa.resource_group_name
    "configuration.backupStorageLocation.config.subscriptionId" = data.azurerm_client_config.current.subscription_id
    "credentials.tenantId"                                      = data.azurerm_client_config.current.tenant_id
  }
  depends_on = [azurerm_storage_container.backupcontainer]
}

#Assign Role to Extension Identity over Storage Account
resource "azurerm_role_assignment" "extensionrole" {
  scope                = azurerm_storage_account.backupsa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_kubernetes_cluster_extension.dataprotection.aks_assigned_identity[0].principal_id
  depends_on           = [azurerm_kubernetes_cluster_extension.dataprotection]
}

#Assign Role to Backup Vault over AKS Cluster
resource "azurerm_role_assignment" "vault_msi_read_on_cluster" {
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
  depends_on           = [azurerm_kubernetes_cluster.k8s]
}

#Assign Role to Backup Vault over Snapshot Resource Group
resource "azurerm_role_assignment" "vault_msi_read_on_snap_rg" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
  depends_on           = [azurerm_kubernetes_cluster.k8s]
}

#Assign Role to AKS Cluster over Snapshot Resource Group
resource "azurerm_role_assignment" "cluster_msi_contributor_on_snap_rg" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = try(azurerm_kubernetes_cluster.k8s.identity[0].principal_id, null)
  depends_on           = [azurerm_kubernetes_cluster.k8s]
}

# Create Backup Instance for AKS Cluster
resource "azurerm_data_protection_backup_instance_kubernetes_cluster" "akstfbi" {
  name                         = "${local.prefix}-backup-instance"
  location                     = var.location
  vault_id                     = azurerm_data_protection_backup_vault.aks-backup-vault.id
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.k8s.id
  snapshot_resource_group_name = var.resource_group
  backup_policy_id             = azurerm_data_protection_backup_policy_kubernetes_cluster.policy.id

  backup_datasource_parameters {
    excluded_namespaces              = var.backup_excluded_namespaces
    excluded_resource_types          = var.backup_excluded_resource_types
    cluster_scoped_resources_enabled = true
    included_namespaces              = var.backup_included_namespaces
    included_resource_types          = var.backup_included_resource_types
    label_selectors                  = var.backup_label_selectors
    volume_snapshot_enabled          = true
  }

  depends_on = [
    azurerm_data_protection_backup_vault.aks-backup-vault,
    azurerm_data_protection_backup_policy_kubernetes_cluster.policy,
    azurerm_role_assignment.extensionrole,
    azurerm_role_assignment.vault_msi_read_on_cluster,
    azurerm_role_assignment.vault_msi_read_on_snap_rg,
    azurerm_role_assignment.cluster_msi_contributor_on_snap_rg
  ]
}
