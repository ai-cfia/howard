resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.rg_name

  soa_record {
    email = var.soa_record_tech_contact_email
  }

  tags = var.tags
}

resource "azurerm_dns_a_record" "dns_zone_a_record" {
  name                = var.dns_a_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = var.dns_a_records

  tags = var.tags
}

resource "azurerm_dns_cname_record" "dns_zone_cname_record" {
  name                = "nginx"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  record              = azurerm_dns_a_record.dns_zone_a_record.fqdn

  tags = var.tags
}
