resource "azurerm_firewall_policy_rule_collection_group" "aks_egress" {
  count              = var.enable_firewall ? 1 : 0
  name               = "rcg-aks-egress"
  firewall_policy_id = azurerm_firewall_policy.main[0].id
  priority           = 100

  application_rule_collection {
    name     = "arc-aks-required"
    priority = 100
    action   = "Allow"

    rule {
      name             = "allow-azure-services"
      source_addresses = var.aks_subnet_address_prefixes
      protocols {
        type = "Https"
        port = 443
      }
      destination_fqdns = [
        "*.hcp.${var.location}.azmk8s.io",
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "management.azure.com",
        "login.microsoftonline.com",
        "packages.microsoft.com",
        "acs-mirror.azureedge.net",
      ]
    }

    rule {
      name             = "allow-ubuntu-updates"
      source_addresses = var.aks_subnet_address_prefixes
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      destination_fqdns = [
        "security.ubuntu.com",
        "azure.archive.ubuntu.com",
        "changelogs.ubuntu.com",
      ]
    }
  }

  network_rule_collection {
    name     = "nrc-aks-dns"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "allow-dns"
      source_addresses      = var.aks_subnet_address_prefixes
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    }
  }
}
