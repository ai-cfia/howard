variable "location_1" {
  description = "Azure cloud first computing region"
  type        = string
}

# variable "location_2" {
#   description = "Azure cloud second computing region"
#   type        = string

# }

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

variable "virtual_network_address" {
  description = "Virtual network address"
  type        = string
  default     = "10.0.0.0/16" # RFC1918-compliant private address space
}

variable "subnet_address" {
  description = "Subnet address"
  type        = string
  default     = "10.241.0.0/16" # Subnet resides within RFC1918-compliant VNet range
}

variable "dev_subnet_address" {
  description = "Subnet address for Dev environment services"
  type        = string
  default     = "10.242.0.0/16" # Subnet resides within RFC1918-compliant VNet range
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

variable "soa_record_tech_contact_email" {
  description = "SOA Record tech contact email (no @ inside the email)"
  type        = string
}

variable "dns_zone_name" {
  description = "azurerm_dns_zone name"
  type        = string
}

variable "dns_a_record_name" {
  description = "DNS A Record name"
  type        = string
}

variable "dns_a_records" {
  description = "DNS A records list"
  type        = list(string)
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

# variable "vm_rg_name" {
#   type        = string
#   description = "The resource group name for each vm's"
# }

# variable "vm_location" {
#   type        = string
#   description = "Location of each vm's"
# }

# variable "vm_virtual_network_name" {
#   type        = string
#   description = "VM virtual network name"
# }

# variable "vm_virtual_network_address_space" {
#   type        = list(string)
#   description = "VM virtual network name address space"
# }

# variable "vm_public_ip_name" {
#   type        = string
#   description = "VM public ip name"
# }

# variable "vm_public_ip_allocation_method" {
#   type        = string
#   description = "VM public ip allocation method"
#   default     = "Static"
# }

# variable "vm_virtual_network_subnet_name" {
#   type        = string
#   description = "VM virtual network subnet name"
# }

# variable "vm_virtual_network_subnet_address_prefixes" {
#   type        = list(string)
#   description = "VM virtual network subnet address prefixed"
# }

# variable "bastion_virtual_network_subnet_name" {
#   type        = string
#   description = "VM virtual network subnet name"
# }

# variable "bastion_virtual_network_subnet_address_prefixes" {
#   type        = list(string)
#   description = "VM virtual network subnet address prefixed"
# }

# variable "vm_network_interface_name" {
#   type        = string
#   description = "VM virtual network interface name"
# }

# variable "vm_network_interface_ip_configuration_name" {
#   type        = string
#   description = "VM virtual network ip configuration name"
# }

# variable "vm_network_interface_ip_configuration_type" {
#   type        = string
#   description = "VM network interface ip configuration type"
#   default     = "Dynamic"
# }

# variable "linux-vms" {
#   type = map(object({
#     name                            = string
#     size                            = string
#     tags                            = map(string)
#     disable_password_authentication = bool
#     admin_username                  = string
#     admin_password                  = string
#     source_image_reference = object({
#       publisher = string
#       offer     = string
#       sku       = string
#       version   = string
#     })
#     os_disk = object({
#       caching              = string
#       storage_account_type = string
#     })
#   }))
#   description = "Linux VM configuration"
# }

# variable "windows-vms" {
#   type = map(object({
#     name           = string
#     size           = string
#     tags           = map(string)
#     admin_username = string
#     admin_password = string
#     source_image_reference = object({
#       publisher = string
#       offer     = string
#       sku       = string
#       version   = string
#     })
#     os_disk = object({
#       caching              = string
#       storage_account_type = string
#     })
#   }))
#   description = "Windows VM configuration"
# }

# variable "bastion_public_ip_name" {
#   type        = string
#   description = "Bastion public IP name"
# }

# variable "bastion_public_ip_allocation_method" {
#   type        = string
#   description = "Bastion public IP name"
#   default     = "Static"
# }

# variable "bastion_public_ip_sku" {
#   type        = string
#   description = "Bastion public IP sku"
#   default     = "Standard"
# }

# variable "bastion_host_name" {
#   type        = string
#   description = "Bastion hostsname"
# }

# variable "bastion_host_ip_configuration_name" {
#   type        = string
#   description = "Bastion host IP configuration name"
# }

# variable "ad_groups" {
#   description = "ad groups to be used in aks rolebindings"
#   type        = list(string)
# }

# variable "ad_members" {
#   description = "ad members to be added to ad groups"
#   type        = list(string)
# }

# GPU related variables

# variable "aks_gpu_name" {
#   description = "AKS GPU cluster name"
#   type        = string
# }

# variable "default_gpu_node_vm_size" {
#   description = "Size on the main nodepool VM (GPU)"
#   type        = string
#   default     = "Standard_NC6s_v3"
# }

# variable "gpu_node_count" {
#   description = "Number of Cluster Nodes"
#   type        = number
#   default     = 1
# }

# variable "gpu_node_min_count" {
#   description = "Minimum number of nodes in the cluster"
#   type        = number
#   default     = 1
# }

# variable "gpu_node_max_count" {
#   description = "Maximum number of nodes in the cluster"
#   type        = number
#   default     = 10
# }

# variable "second_virtual_network_address" {
#   description = "Second virtual network address"
#   type        = string
#   default     = "10.0.0.0/16" # RFC1918-compliant private address space
# }

# variable "second_subnet_address" {
#   description = "Second subnet address"
#   type        = string
#   default     = "10.241.0.0/16" # Subnet resides within RFC1918-compliant VNet range
# }

# variable "second_pod_cidr" {
#   description = "The CIDR to use for pod IP addresses. Changing this forces a new resource to be created."
#   type        = string
#   default     = "10.244.0.0/16"
# }
