# Network Security Configuration
# Enterprise network controls for Key Vault and security services

# Network Security Group for security resources
resource "azurerm_network_security_group" "security" {
  count               = var.enable_network_security ? 1 : 0
  name                = "nsg-security-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Allow HTTPS inbound for Key Vault access
resource "azurerm_network_security_rule" "allow_https" {
  count                       = var.enable_network_security ? 1 : 0
  name                        = "AllowHTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.allowed_ip_ranges
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.security[0].name
}

# Deny all other inbound traffic
resource "azurerm_network_security_rule" "deny_all_inbound" {
  count                       = var.enable_network_security ? 1 : 0
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.security[0].name
}

# Update Key Vault with network rules
resource "azurerm_key_vault_access_policy" "network_restricted" {
  count        = var.enable_kv_network_restriction ? 1 : 0
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Recover",
    "Purge",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Recover",
    "Purge"
  ]
}

# Private endpoint for Key Vault (optional, requires VNet)
resource "azurerm_private_endpoint" "keyvault" {
  count               = var.enable_private_endpoint && var.subnet_id != "" ? 1 : 0
  name                = "pe-keyvault-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-keyvault-${var.environment}"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}

# Private DNS Zone for Key Vault private endpoint
resource "azurerm_private_dns_zone" "keyvault" {
  count               = var.enable_private_endpoint && var.subnet_id != "" ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Link private DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count                 = var.enable_private_endpoint && var.vnet_id != "" ? 1 : 0
  name                  = "pdnslink-keyvault-${var.environment}"
  resource_group_name   = data.azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}
