variable "additional_node_pools" {
  description = "(Optional) List of additional node pools to the cluster"
  type = map(object({
    vm_size             = string
    os_disk_size_gb     = number
    enable_auto_scaling = bool
    zones               = list(string)
    node_count          = number
    min_count           = number
    max_count           = number
    max_pods            = number
    node_labels         = map(string)
    taints              = list(string)
  }))
  default = {}
}

variable "prefix" {
  description = "(Required) Base name used by resources (cluster name, main service and others)."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group" {
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "network_resource_group" {
  description = "(Required) Name of the resource group that contains the virtual network"
  type        = string
}

variable "network_vnet" {
  description = "(Required) Virtual network name."
  type        = string
}

variable "network_subnet" {
  description = "(Required) Network subnet name."
  type        = string
}

variable "node_count" {
  description = "(Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100 and between min_count and max_count."
  type        = string
}

variable "node_min_count" {
  description = "(Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  type        = number
}

variable "node_max_count" {
  description = "(Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  type        = number
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "k8s_version" {
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
  type        = string
  default     = "1.28"
}

variable "rbac_enabled" {
  description = "(Required) Is Role Based Access Control Enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "vm_size" {
  description = "(Required) The size of the Virtual Machine, such as Standard_DS2_v2."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "auto_scaling_default_node" {
  description = "(Optional) Kubernetes Auto Scaler must be enabled for this main pool"
  type        = bool
}

variable "zones" {
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = []
}

variable "max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 110
}

variable "service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service.Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)."
  type        = string
  default     = "10.0.0.10"
}

variable "pod_cidr" {
  description = "(Optional) The CIDR to use for pod IP addresses. Changing this forces a new resource to be created."
  type        = string
  default     = "10.244.0.0/16"
}

variable "storage_account_name" {
  description = "(Optional) Data storage name (use lower case, no spaces and special characters ex: mystorageaccount).null empty does not create resource."
  type        = string
}

variable "storage_account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Premium"
}

variable "storage_account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  type        = string
  default     = "LRS"
}

variable "storage_account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
  type        = string
  default     = "FileStorage"
}

variable "sku_tier" {
  description = "(Optional) Defines the SLA plan for the availability of system. Valid options are Free or Paid, paid option enables the Uptime SLA feature (see https://docs.microsoft.com/en-us/azure/aks/uptime-sla for more info)"
  type        = string
  default     = "Free"
}

variable "aks_admin_group_object_ids" {
  description = "aks admin group ids"
  type        = list(string)
}

variable "k8s_private_cluster_enabled" {
  description = "K8s private cluster enabled"
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "The identity type of the managed cluster. Possible values are SystemAssigned and UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "The ID of the User Assigned Identity to be used for the managed cluster."
  type        = list(string)
  default     = []
}

variable "azure_backup_vault_name" {
  description = "Azure Backup Vault name"
  type        = string
}

variable "azure_backup_datastore_type" {
  description = "Azure Backup Datastore type"
  type        = string
}

variable "azure_backup_redundancy" {
  description = "Azure Backup Redundancy"
  type        = string
}

variable "azure_backuppolicy_name" {
  description = "Azure Backup Policy name"
  type        = string
}

variable "azure_backup_storage_account_name" {
  description = "Azure backup storage account name"
  type        = string
}

variable "azure_backup_storage_container_name" {
  description = "Azure backup storage container name"
  type        = string
}

variable "azure_backup_extension_type" {
  description = "Type of the AKS Cluster Extension."
  type        = string
  default     = "microsoft.dataprotection.kubernetes"
}

variable "azure_backup_trusted_access" {
  description = "Azure backup trusted access role binding"
  type        = string
}

variable "backup_excluded_namespaces" {
  description = "K8s Namespaces to exclude from backup."
  type        = list(string)
  default     = []
}

variable "backup_excluded_resource_types" {
  description = "K8s Resource Types to exclude from backup."
  type        = list(string)
  default     = []
}

variable "backup_included_namespaces" {
  description = "K8s Namespaces to include in backup."
  type        = list(string)
  default     = []
}

variable "backup_included_resource_types" {
  description = "K8s Resource Types to include in backup."
  type        = list(string)
  default     = []
}

variable "backup_label_selectors" {
  description = "K8s Label Selectors to include in backup."
  type        = list(string)
  default     = []
}

variable "automatic_upgrade_channel" {
  description = "K8s upgrade channel"
  type        = string
  default     = "stable"
}

# variable "aks_service_mesh_profile" {
#   description = "AKS Service mesh profile"
#   default     = "Istio"
#   type        = string
# }

# variable "ad_groups" {
#   description = "ad groups to be used in aks rolebindings"
#   type        = list(string)
# }

# variable "ad_members" {
#   description = "ad members to be added to ad_groups"
#   type        = list(string)
# }
