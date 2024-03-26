resource "azurerm_linux_virtual_machine" "linux-vm" {
  for_each = var.linux-vms

  name                            = each.value.name
  size                            = each.value.size
  disable_password_authentication = each.value.disable_password_authentication

  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]

  computer_name  = each.value.name
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password


  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  tags = each.value.tags
}

resource "azurerm_windows_virtual_machine" "windows-vm" {
  for_each = var.windows-vms

  name = each.value.name
  size = each.value.size

  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]

  computer_name  = each.value.name
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  tags = each.value.tags
}
