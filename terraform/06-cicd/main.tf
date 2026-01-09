# Terraform configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Data sources
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

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

# Get observability outputs from remote state
data "terraform_remote_state" "observability" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "observability"
    key                  = "observability.tfstate"
    use_azuread_auth     = true
  }
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "cicd" {
  name                = "aks-${var.component_name}-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "${var.aks_dns_prefix}-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  # System node pool (always-on)
  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = var.system_node_size
    vnet_subnet_id      = data.terraform_remote_state.networking.outputs.aks_cicd_subnet_id
    enable_auto_scaling = false

    node_labels = {
      "workload" = "system"
    }

    tags = var.tags
  }

  # Identity for AKS cluster
  identity {
    type = "SystemAssigned"
  }

  # Network profile
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
  }

  # Security settings
  azure_policy_enabled = true

  # Monitoring integration
  oms_agent {
    log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
  }

  tags = var.tags
}

# Kubernetes and Helm provider configuration
# Note: Providers are configured after AKS cluster creation
# These will be evaluated during terraform apply phase

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.cicd.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.cicd.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cicd.kube_config.0.cluster_ca_certificate)
  }
}

# Runner node pool (scale-to-zero for cost optimization)
resource "azurerm_kubernetes_cluster_node_pool" "runners" {
  name                  = "runners"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cicd.id
  vm_size               = var.runner_node_size
  vnet_subnet_id        = data.terraform_remote_state.networking.outputs.aks_cicd_subnet_id

  # Autoscaling configuration (scale to zero)
  enable_auto_scaling = true
  min_count           = var.runner_node_min_count # 0
  max_count           = var.runner_node_max_count # 5
  node_count          = null                      # Required when auto-scaling

  # Node labels and taints for runner workloads only
  node_labels = {
    "workload" = "github-runners"
  }

  node_taints = [
    "workload=github-runners:NoSchedule"
  ]

  tags = var.tags
}
