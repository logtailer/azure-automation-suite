terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Data source for AKS cluster from remote state
data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group
    storage_account_name = var.tfstate_storage_account
    container_name       = "aks"
    key                  = "terraform.tfstate"
  }
}

# Configure Kubernetes provider using AKS cluster
provider "kubernetes" {
  host                   = data.terraform_remote_state.aks.outputs.kube_config.0.host
  client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.client_certificate)
  client_key            = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.aks.outputs.kube_config.0.host
    client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.client_certificate)
    client_key            = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.kube_config.0.cluster_ca_certificate)
  }
}

# Namespace for Backstage IDP
resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"
    labels = {
      "app.kubernetes.io/name"      = "backstage"
      "app.kubernetes.io/instance"  = "backstage-idp"
      "app.kubernetes.io/component" = "internal-developer-platform"
    }
  }
}

# PostgreSQL database for Backstage
resource "azurerm_postgresql_flexible_server" "backstage_db" {
  name                   = var.postgresql_server_name
  resource_group_name    = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  version               = "13"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  zone                  = "1"
  storage_mb            = 32768
  sku_name              = "B_Standard_B1ms"

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "backstage" {
  name      = "backstage"
  server_id = azurerm_postgresql_flexible_server.backstage_db.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Secret for database connection
resource "kubernetes_secret" "backstage_db" {
  metadata {
    name      = "backstage-db-secret"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }

  data = {
    POSTGRES_HOST     = azurerm_postgresql_flexible_server.backstage_db.fqdn
    POSTGRES_PORT     = "5432"
    POSTGRES_USER     = var.db_admin_username
    POSTGRES_PASSWORD = var.db_admin_password
    DATABASE_NAME     = azurerm_postgresql_flexible_server_database.backstage.name
  }
}

# ConfigMap for Backstage configuration
resource "kubernetes_config_map" "backstage_config" {
  metadata {
    name      = "backstage-config"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }

  data = {
    "app-config.yaml" = templatefile("${path.module}/templates/app-config.yaml", {
      postgres_host     = azurerm_postgresql_flexible_server.backstage_db.fqdn
      postgres_port     = "5432"
      postgres_user     = var.db_admin_username
      postgres_db       = azurerm_postgresql_flexible_server_database.backstage.name
      github_token      = var.github_token
      github_org        = var.github_organization
      auth_github_id    = var.github_client_id
      auth_github_secret = var.github_client_secret
    })
  }
}

# Helm release for Backstage
resource "helm_release" "backstage" {
  name       = "backstage"
  namespace  = kubernetes_namespace.backstage.metadata[0].name
  chart      = "backstage"
  repository = "https://backstage.github.io/charts"
  version    = "1.0.0"

  values = [
    templatefile("${path.module}/templates/backstage-values.yaml", {
      db_secret_name = kubernetes_secret.backstage_db.metadata[0].name
      config_map_name = kubernetes_config_map.backstage_config.metadata[0].name
    })
  ]

  depends_on = [
    azurerm_postgresql_flexible_server.backstage_db,
    kubernetes_secret.backstage_db,
    kubernetes_config_map.backstage_config
  ]
}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
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

# Get current client configuration
data "azuread_client_config" "current" {}
