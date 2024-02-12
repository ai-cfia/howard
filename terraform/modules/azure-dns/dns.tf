resource "azurerm_resource_group" "rg" {
  name     = var.rg-name
  location = var.region

  tags = {
    created-by   = var.created-by
    tech-contact = var.tech-contact
    environment  = var.environment
  }
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns-zone-name
  resource_group_name = azurerm_resource_group.rg.name

  soa_record {
    email = var.tech-contact
  }

  tags = {
    created-by   = var.created-by
    tech-contact = var.tech-contact
    environment  = var.environment
  }
}
