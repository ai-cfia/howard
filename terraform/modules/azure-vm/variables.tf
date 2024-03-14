variable "vm_rg_name" {
  type        = string
  description = "The resource group name for each vm's"
}

variable "vm_location" {
  type        = string
  description = "Location of each vm's"
}

variable "vm_virtual_network_name" {
  type        = string
  description = "VM virtual network name"
}

variable "vm_virtual_network_address_space" {
  type        = list(string)
  description = "VM virtual network name address space"
}

variable "vm_virtual_network_subnet_name" {
  type        = string
  description = "VM virtual network subnet name"
}

variable "vm_virtual_network_subnet_address_prefixes" {
  type        = list(string)
  description = "VM virtual network subnet address prefixed"
}

variable "vm_network_interface_name" {
  type        = string
  description = "VM virtual network interface name"
}

variable "vm_network_interface_ip_configuration_name" {
  type        = string
  description = "VM virtual network ip configuration name"
}

variable "vm_network_interface_ip_configuration_type" {
  type        = string
  description = "VM network interface ip configuration type"
  default     = "Dynamic"
}

variable "vms" {
  type = map(object({
    name                             = string
    vm_size                          = string
    delete_os_disk_on_termination    = bool
    delete_data_disks_on_termination = bool
    tags                             = map(string)
    storage_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    storage_os_disk = object({
      name              = string
      caching           = string
      create_option     = string
      managed_disk_type = string
    })
    os_profile = object({
      computer_name  = string
      admin_username = string
      admin_password = string
    })
    os_profile_linux_config = object({
      disable_password_authentication = bool
    })
  }))
  description = "VM configuration"
}

variable "bastion_public_ip_name" {
  type        = string
  description = "Bastion public IP name"
}

variable "bastion_public_ip_allocation_method" {
  type        = string
  description = "Bastion public IP name"
  default     = "Static"
}

variable "bastion_public_ip_sku" {
  type        = string
  description = "Bastion public IP sku"
  default     = "Standard"
}

variable "bastion_host_name" {
  type        = string
  description = "Bastion hostsname"
}

variable "bastion_host_ip_configuration_name" {
  type        = string
  description = "Bastion host IP configuration name"
}
