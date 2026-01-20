terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "foundation" {
  name = var.foundation_resource_group_name
}

# Traffic Manager Profile for multi-region failover
resource "azurerm_traffic_manager_profile" "main" {
  name                   = var.traffic_manager_name
  resource_group_name    = data.azurerm_resource_group.foundation.name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = var.traffic_manager_name
    ttl           = 60
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/health"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  tags = var.tags
}
