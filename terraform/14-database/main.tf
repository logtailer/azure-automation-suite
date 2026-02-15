terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "main" {
  count               = var.enable_postgresql ? 1 : 0
  name                = var.postgresql_server_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  administrator_login    = var.postgresql_admin_login
  administrator_password = var.postgresql_admin_password

  sku_name   = var.postgresql_sku_name
  storage_mb = var.postgresql_storage_mb
  version    = var.postgresql_version

  backup_retention_days        = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup

  tags = local.common_tags
}

resource "azurerm_mysql_flexible_server" "main" {
  count               = var.enable_mysql ? 1 : 0
  name                = var.mysql_server_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  administrator_login    = var.mysql_admin_login
  administrator_password = var.mysql_admin_password

  sku_name = var.mysql_sku_name
  version  = var.mysql_version

  backup_retention_days        = var.mysql_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_geo_redundant_backup

  tags = local.common_tags
}

resource "azurerm_redis_cache" "main" {
  count               = var.enable_redis ? 1 : 0
  name                = var.redis_cache_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name

  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  tags = local.common_tags
}
