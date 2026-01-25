terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Get current client configuration
data "azuread_client_config" "current" {}

# Random ID for DNS suffix to ensure uniqueness
resource "random_id" "dns_suffix" {
  byte_length = 4
}

# User-assigned managed identity for the container
resource "azurerm_user_assigned_identity" "backstage" {
  name                = "id-backstage-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Azure Container Registry for Backstage image
resource "azurerm_container_registry" "backstage" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = var.tags
}

# PostgreSQL database for Backstage
resource "azurerm_postgresql_flexible_server" "backstage_db" {
  name                   = var.postgresql_server_name
  resource_group_name    = data.azurerm_resource_group.main.name
  location               = data.azurerm_resource_group.main.location
  version                = "13"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "backstage" {
  name      = "backstage"
  server_id = azurerm_postgresql_flexible_server.backstage_db.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Azure Container Instances for Backstage
resource "azurerm_container_group" "backstage" {
  name                = "ci-backstage-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "backstage-${var.environment}-${random_id.dns_suffix.hex}"
  os_type             = "Linux"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.backstage.id]
  }

  image_registry_credential {
    username = azurerm_container_registry.backstage.admin_username
    password = azurerm_container_registry.backstage.admin_password
    server   = azurerm_container_registry.backstage.login_server
  }

  container {
    name   = "backstage"
    image  = "${azurerm_container_registry.backstage.login_server}/backstage:latest"
    cpu    = "1.0"
    memory = "2.0"

    ports {
      port     = 7007
      protocol = "TCP"
    }

    environment_variables = {
      POSTGRES_HOST = azurerm_postgresql_flexible_server.backstage_db.fqdn
      POSTGRES_PORT = "5432"
      POSTGRES_USER = var.db_admin_username
      POSTGRES_DB   = azurerm_postgresql_flexible_server_database.backstage.name
      GITHUB_ORG    = var.github_organization
    }

    secure_environment_variables = {
      POSTGRES_PASSWORD    = var.db_admin_password
      GITHUB_TOKEN         = var.github_token
      GITHUB_CLIENT_ID     = var.github_client_id
      GITHUB_CLIENT_SECRET = var.github_client_secret
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_postgresql_flexible_server.backstage_db,
    azurerm_container_registry.backstage
  ]
}

# Azure AD Application for the platform
resource "azuread_application" "platform" {
  display_name     = var.application_name
  sign_in_audience = "AzureADMyOrg"

  web {
    homepage_url  = var.homepage_url
    redirect_uris = var.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access platform APIs on behalf of the signed-in user"
      admin_consent_display_name = "Access platform APIs"
      enabled                    = true
      id                         = "b5c7c7c7-0000-0000-0000-000000000001"
      type                       = "User"
      user_consent_description   = "Allow the application to access platform APIs on your behalf"
      user_consent_display_name  = "Access platform APIs"
      value                      = "platform.access"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  tags = var.tags
}

# Service Principal for the application
resource "azuread_service_principal" "platform" {
  client_id = azuread_application.platform.application_id
  owners    = [data.azuread_client_config.current.object_id]

  tags = var.tags
}

# Client secret for the application
resource "azuread_application_password" "platform" {
  application_id = azuread_application.platform.id
  display_name   = "Platform Client Secret"
  end_date       = timeadd(timestamp(), "8760h") # 1 year from now
}

# Azure AD Groups for RBAC
resource "azuread_group" "platform_admins" {
  display_name     = var.admin_group_name
  description      = "Platform administrators with full access"
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_group" "platform_developers" {
  display_name     = var.developer_group_name
  description      = "Platform developers with limited access"
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_group" "platform_viewers" {
  display_name     = var.viewer_group_name
  description      = "Platform viewers with read-only access"
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}
