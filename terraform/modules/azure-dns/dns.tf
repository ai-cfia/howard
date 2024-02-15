resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_name
  resource_group_name = var.rg_name

  soa_record {
    email = var.soa_record_tech_contact_email
  }

  tags = var.tags
}
