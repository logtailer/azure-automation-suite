# Development environment orchestration
# This file orchestrates all components for the dev environment

terraform {
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

# Core infrastructure
module "core" {
  source = "../../core"

  project_name = var.project_name
  environment  = "dev"
  location     = var.location

  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Security infrastructure
module "security" {
  source = "../../security"

  project_name = var.project_name
  environment  = "dev"

  tfstate_resource_group_name  = var.tfstate_resource_group_name
  tfstate_storage_account_name = var.tfstate_storage_account_name

  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }

  depends_on = [module.core]
}
