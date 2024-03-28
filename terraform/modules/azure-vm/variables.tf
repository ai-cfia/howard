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

variable "vm_public_ip_name" {
  type        = string
  description = "VM public ip name"
}

variable "vm_public_ip_allocation_method" {
  type        = string
  description = "VM public ip allocation method"
  default     = "Static"
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

variable "bastion_virtual_network_subnet_name" {
  type        = string
  description = "Bastion virtual network subnet name"
}

variable "bastion_virtual_network_subnet_address_prefixes" {
  type        = list(string)
  description = "Bastion virtual network subnet address prefixed"
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

variable "linux-vms" {
  type = map(object({
    name                            = string
    size                            = string
    tags                            = map(string)
    disable_password_authentication = bool
    admin_username                  = string
    admin_password                  = string
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
  }))
  description = "Linux VM configuration"
}

variable "windows-vms" {
  type = map(object({
    name           = string
    size           = string
    tags           = map(string)
    admin_username = string
    admin_password = string
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
  }))
  description = "Windows VM configuration"
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
