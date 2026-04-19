data "azurerm_subscription" "current_security" {}

resource "azurerm_role_definition" "aks_operator" {
  count       = var.enable_custom_aks_role ? 1 : 0
  name        = "AKS Operator - ${var.environment}"
  scope       = data.azurerm_subscription.current_security.id
  description = "Manage AKS clusters without access to networking or security resources"

  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/write",
      "Microsoft.ContainerService/managedClusters/delete",
      "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
      "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
      "Microsoft.ContainerService/managedClusters/agentPools/read",
      "Microsoft.ContainerService/managedClusters/agentPools/write",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
    ]
    not_actions = []
  }

  assignable_scopes = [data.azurerm_subscription.current_security.id]
}

resource "azurerm_role_definition" "secret_reader" {
  count       = var.enable_custom_secret_role ? 1 : 0
  name        = "Secret Reader - ${var.environment}"
  scope       = data.azurerm_subscription.current_security.id
  description = "Read-only access to Key Vault secrets, cannot list or manage vaults"

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/secrets/getSecret/action",
      "Microsoft.KeyVault/vaults/secrets/readMetadata/action",
    ]
    not_actions = []
  }

  assignable_scopes = [data.azurerm_subscription.current_security.id]
}
