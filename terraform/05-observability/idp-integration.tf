# IDP Module Integration for Cross-Module Monitoring
# This file enables the observability module to monitor IDP (Backstage) resources

# Data source to access IDP module remote state
data "terraform_remote_state" "idp" {
  count   = var.enable_idp_monitoring ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "idp"
    key                  = "idp.tfstate"
  }
}

# Note: This data source provides access to IDP module outputs:
# - data.terraform_remote_state.idp[0].outputs.container_group_name (ACI resource ID)
# - data.terraform_remote_state.idp[0].outputs.postgresql_server_name (PostgreSQL resource ID)
# - data.terraform_remote_state.idp[0].outputs.container_registry_name (ACR resource ID)
# - data.terraform_remote_state.idp[0].outputs.resource_group_id (IDP resource group ID)
#
# These outputs are used by:
# - aci-alerts.tf (Container Instance monitoring)
# - database-alerts.tf (PostgreSQL monitoring)
# - Diagnostic settings (log shipping to Log Analytics)
# - Grafana role assignments (Monitoring Reader access)
