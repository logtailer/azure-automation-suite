# Terraform configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Backend configuration will be provided via -backend-config during init
}

provider "azurerm" {
  features {}
}

# Data sources
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Random suffix for DNS label uniqueness
resource "random_id" "dns_suffix" {
  byte_length = 4
}

# Random suffix for storage account name uniqueness
resource "random_id" "storage_suffix" {
  byte_length = 3
}

# User-Assigned Managed Identity for Nexus container
resource "azurerm_user_assigned_identity" "nexus" {
  name                = "id-nexus-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Azure Container Registry for Nexus images
resource "azurerm_container_registry" "nexus" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = var.container_registry_sku
  admin_enabled       = false

  tags = var.tags
}

# Grant AcrPull role to managed identity
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.nexus.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.nexus.principal_id
}

# Storage Account for Nexus persistent data
resource "azurerm_storage_account" "nexus_data" {
  name                            = "stnexusdata${var.environment}${random_id.storage_suffix.hex}"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = element(split("_", var.storage_account_sku), 1)
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Azure Files share for /nexus-data persistent storage
resource "azurerm_storage_share" "nexus_data" {
  name                 = "nexus-data"
  storage_account_name = azurerm_storage_account.nexus_data.name
  quota                = var.file_share_quota

  depends_on = [azurerm_storage_account.nexus_data]
}

# Azure Container Instance for Nexus OSS
resource "azurerm_container_group" "nexus" {
  name                = "ci-nexus-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "nexus-${var.environment}-${random_id.dns_suffix.hex}"
  os_type             = "Linux"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.nexus.id]
  }

  image_registry_credential {
    user_assigned_identity_id = azurerm_user_assigned_identity.nexus.id
    server                    = azurerm_container_registry.nexus.login_server
  }

  container {
    name   = "nexus"
    image  = "${azurerm_container_registry.nexus.login_server}/nexus:${var.nexus_image_tag}"
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = 8081
      protocol = "TCP"
    }

    environment_variables = {
      INSTALL4J_ADD_VM_PARAMS = "-Xms2g -Xmx2g -XX:MaxDirectMemorySize=2g"
    }

    volume {
      name                 = "nexus-data"
      mount_path           = "/nexus-data"
      storage_account_name = azurerm_storage_account.nexus_data.name
      storage_account_key  = azurerm_storage_account.nexus_data.primary_access_key
      share_name           = azurerm_storage_share.nexus_data.name
      read_only            = false
    }

    liveness_probe {
      http_get {
        path   = "/service/rest/v1/status"
        port   = 8081
        scheme = "Http"
      }
      initial_delay_seconds = var.liveness_initial_delay
      period_seconds        = 30
      failure_threshold     = 5
      timeout_seconds       = 10
    }

    readiness_probe {
      http_get {
        path   = "/service/rest/v1/status"
        port   = 8081
        scheme = "Http"
      }
      initial_delay_seconds = var.readiness_initial_delay
      period_seconds        = 10
      failure_threshold     = 3
      success_threshold     = 1
      timeout_seconds       = 5
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_storage_share.nexus_data
  ]
}
