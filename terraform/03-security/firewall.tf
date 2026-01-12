# Azure Firewall - Network security appliance
# Provides centralized network security and threat protection

# Get networking outputs from remote state
data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "networking"
    key                  = "networking.tfstate"
    use_azuread_auth     = true
  }
}

# Public IP for Azure Firewall
resource "azurerm_public_ip" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  name                = "pip-firewall-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "afw-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.main[0].id

  ip_configuration {
    name                 = "firewall-ipconfig"
    subnet_id            = data.terraform_remote_state.networking.outputs.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }

  tags = var.tags
}

# Firewall Policy
resource "azurerm_firewall_policy" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "afwp-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.firewall_sku_tier

  threat_intelligence_mode = "Alert"

  dns {
    proxy_enabled = true
  }

  intrusion_detection {
    mode = var.firewall_intrusion_detection_mode
  }

  tags = var.tags
}

# Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  count              = var.enable_firewall ? 1 : 0
  name               = "network-rules"
  firewall_policy_id = azurerm_firewall_policy.main[0].id
  priority           = 100

  network_rule_collection {
    name     = "allow-outbound"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-dns"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "allow-ntp"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }

    rule {
      name                  = "allow-https"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["443"]
    }

    rule {
      name                  = "allow-http"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["80"]
    }
  }
}

# Application rules for specific FQDNs
resource "azurerm_firewall_policy_rule_collection_group" "application_rules" {
  count              = var.enable_firewall ? 1 : 0
  name               = "application-rules"
  firewall_policy_id = azurerm_firewall_policy.main[0].id
  priority           = 200

  application_rule_collection {
    name     = "allow-azure-services"
    priority = 200
    action   = "Allow"

    rule {
      name = "allow-azure-monitor"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = ["10.0.0.0/16"]
      destination_fqdn_tags = ["AzureMonitor"]
    }

    rule {
      name = "allow-azure-storage"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.0.0.0/16"]
      destination_fqdns = [
        "*.blob.core.windows.net",
        "*.table.core.windows.net",
        "*.queue.core.windows.net"
      ]
    }

    rule {
      name = "allow-container-registry"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.0.0.0/16"]
      destination_fqdns = [
        "*.azurecr.io",
        "*.mcr.microsoft.com"
      ]
    }
  }
}

# Diagnostic settings for Firewall
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count                      = var.enable_firewall ? 1 : 0
  name                       = "firewall-diagnostics"
  target_resource_id         = azurerm_firewall.main[0].id
  log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
