resource "azurerm_private_link_service" "main" {
  count               = var.enable_private_link_service ? 1 : 0
  name                = "pls-${var.vnet_name}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location

  nat_ip_configuration {
    name                       = "primary"
    subnet_id                  = azurerm_subnet.private.id
    private_ip_address_version = "IPv4"
    primary                    = true
  }

  load_balancer_frontend_ip_configuration_ids = [
    var.internal_lb_frontend_ip_id
  ]

  auto_approval_subscription_ids  = var.pls_auto_approval_subscription_ids
  visibility_subscription_ids     = var.pls_visibility_subscription_ids
  enable_proxy_protocol           = false

  tags = var.tags
}

resource "azurerm_private_endpoint" "custom" {
  for_each            = var.enable_private_link_service ? var.custom_private_endpoints : {}
  name                = "pe-${each.key}"
  resource_group_name = var.foundation_resource_group_name
  location            = var.location
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = each.value.manual
    request_message                = each.value.manual ? "Approved by platform team" : null
  }

  tags = var.tags
}
