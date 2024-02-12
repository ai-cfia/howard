variable "location_1" {
  description = "Azure cloud first computing region"
}

# variable "location_2" {
#   description = "Azure cloud second computing region"
# }

variable "resource_group" {
  description = "Resource group name"
}

variable "aks_name" {
  description = "AKS cluster name"
}

variable "admin_username" {
  description = "User to access the virtual machines of the system (use lower case, no spaces and special characters ex: azureuser)"
}

variable "k8s_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  default     = "2.24.0"
}

variable "default_node_vm_size" {
  description = "Size of the main nodepool VM"
  default     = "Standard_E8as_v4"
}

variable "auto_scaling_default_node" {
  description = "Enables auto-scaling of the main node"
  default     = true
}

variable "zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["1", "2"]
}

variable "node_count" {
  description = "Number of Cluster Nodes"
  default     = 1
}

variable "node_min_count" {
  description = "Minimum number of nodes in the cluster"
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes in the cluster"
  default     = 10
}

variable "max_pods" {
  description = "Total number of pods that can be started on a kubernetes node "
  default     = 110
}

variable "virtual_network_address" {
  description = "Virtual network address"
  default     = "10.0.0.0/16" # RFC1918-compliant private address space
}

variable "subnet_address" {
  description = "Subnet address"
  default     = "10.241.0.0/16" # Subnet resides within RFC1918-compliant VNet range
}

variable "service_cidr" {
  description = "The Network Range used by the Kubernetes service.Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)."
  default     = "10.0.0.10"
}

variable "pod_cidr" {
  description = "The CIDR to use for pod IP addresses. Changing this forces a new resource to be created."
  default     = "10.244.0.0/16"
}

variable "docker_bridge_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  default     = "172.17.0.1/16"
}

variable "additional_node_pools" {
  description = "List of additional node pools to the cluster."
  default     = {}
}

variable "tags" {
  description = "Azure resource tags"
  default     = {}
}

variable "sku_tier" {
  description = "Defines the SLA plan for the availability of system. Valid options are Free or Paid, paid option enables the Uptime SLA feature (see https://docs.microsoft.com/en-us/azure/aks/uptime-sla for more info). Not needed for staging env."
  type        = string
  default     = "Free"
}

variable "aks_admin_group_object_ids" {
  description = "aks admin group ids"
  type        = list(string)
}

variable "ad_groups" {
  description = "ad groups to be used in aks rolebindings"
  type        = list(string)
}
