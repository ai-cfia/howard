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

resource "azurerm_dns_mx_record" "dns_zone_mx_record" {
  name                = var.dns_mx_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  record {
    preference = 0
    exchange = "."
  }

  tags = var.tags
}

resource "azurerm_dns_txt_record" "dns_zone_txt_record_spf" {
  name                = var.dns_txt_record_name_spf
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  record {
    value = "v=spf1 -all"
  }

  tags = var.tags
}

resource "azurerm_dns_txt_record" "dns_zone_txt_record_dkim" {
  name                = var.dns_txt_record_name_dkim
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  record {
    value = "v=DKIM1; p="
  }

  tags = var.tags
}

resource "azurerm_dns_txt_record" "dns_zone_txt_record_dmarc" {
  name                = var.dns_txt_record_name_dmarc
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  record {
    value = "v=DMARC1;p=reject;sp=reject;adkim=s;aspf=s;rua=mailto:ssc.dmarc.spc@canada.ca,mailto:dmarc@cyber.gc.ca;"
  }

  tags = var.tags
}
