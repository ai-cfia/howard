variable "location_1" {
  description = "Azure cloud first computing region"
  type        = string
}

variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "environment" {
  type        = string
  description = "Name of the deployment environment"
  default     = "staging"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
}

variable "k8s_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = "2.24.0"
}

variable "default_node_vm_size" {
  description = "Size of the main nodepool VM"
  type        = string
  default     = "Standard_E8as_v4"
}

variable "auto_scaling_default_node" {
  description = "Enables auto-scaling of the main node"
  type        = bool
  default     = true
}

variable "zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["1"]
}

variable "node_count" {
  description = "Number of Cluster Nodes"
  type        = number
  default     = 1
}

variable "node_min_count" {
  description = "Minimum number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes in the cluster"
  type        = number
  default     = 10
}

variable "max_pods" {
  description = "Total number of pods that can be started on a kubernetes node "
  type        = number
  default     = 110
}

variable "service_cidr" {
  description = "The Network Range used by the Kubernetes service.Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)."
  type        = string
  default     = "10.0.0.10"
}

variable "pod_cidr" {
  description = "The CIDR to use for pod IP addresses. Changing this forces a new resource to be created."
  type        = string
  default     = "10.244.0.0/16"
}

variable "additional_node_pools" {
  description = "List of additional node pools to the cluster."
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

variable "tags" {
  description = "Azure resource tags"
  type        = map(string)
  default     = {}
}

variable "sku_tier" {
  description = "Defines the SLA plan for the availability of system. Valid options are Free or Paid, paid option enables the Uptime SLA feature (see https://docs.microsoft.com/en-us/azure/aks/uptime-sla for more info). Not needed for staging env."
  type        = string
  default     = "Free"
}

variable "managed" {
  description = "(Optional) Is this a managed Kubernetes Cluster? Default is true."
  type        = bool
  default     = true
}

variable "rbac_enabled" {
  description = "(Required) Is Role Based Access Control Enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "aks_admin_group_object_ids" {
  description = "aks admin group ids"
  type        = list(string)
}

# variable "soa_record_tech_contact_email" {
#   description = "SOA Record tech contact email (no @ inside the email)"
#   type        = string
# }

# variable "dns_zone_name" {
#   description = "azurerm_dns_zone name"
#   type        = string
# }

# variable "dns_a_record_name" {
#   description = "DNS A Record name"
#   type        = string
# }

# variable "dns_a_records" {
#   description = "DNS A records list"
#   type        = list(string)
# }

# variable "vnet-private-network-name" {
#   description = "Private virtual network name"
#   type        = string
# }

# variable "vnet-private-network-subnet" {
#   description = "Private virtual network subnet"
#   type        = string
# }

variable "vnet-network-name" {
  description = "Virtual network name"
  type        = string
}

variable "vnet-network-address-space" {
  description = "Virtual network address space"
  type        = string
}

variable "vnet-network-subnet-name" {
  description = "Virtual network name"
  type        = string
}

variable "key_vault_name" {
  description = "Azure key vault name"
  type        = string
}

variable "key_vault_resource_group_name" {
  description = "Azure key vault resource group name"
  type        = string
}

variable "key_vault_resource_group_location" {
  description = "Azure key vault resource group location"
  type        = string
}

variable "key_vault_key_permissions" {
  description = "Azure key vault key permissions"
  type        = list(string)
}

variable "key_vault_secret_permissions" {
  description = "Azure key vault secret permissions"
  type        = list(string)
}

variable "key_vault_storage_permissions" {
  description = "Azure key vault storage permissions"
  type        = list(string)
}
