# Managed Identities for Enterprise Workloads
# Centralized identity management for applications and services

# Platform-wide managed identity for AKS workloads
resource "azurerm_user_assigned_identity" "aks_workload" {
  count               = var.enable_aks_identity ? 1 : 0
  name                = "id-aks-workload-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Managed identity for application workloads (general purpose)
resource "azurerm_user_assigned_identity" "app_workload" {
  count               = var.enable_app_identity ? 1 : 0
  name                = "id-app-workload-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Managed identity for DevOps automation
resource "azurerm_user_assigned_identity" "devops" {
  count               = var.enable_devops_identity ? 1 : 0
  name                = "id-devops-automation-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Managed identity for monitoring and observability
resource "azurerm_user_assigned_identity" "monitoring" {
  count               = var.enable_monitoring_identity ? 1 : 0
  name                = "id-monitoring-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}
