resource "azurerm_subscription_policy_remediation" "require_tags" {
  count                   = var.enforce_policies ? 1 : 0
  name                    = "remediation-require-tags"
  subscription_id         = data.azurerm_subscription.current.id
  policy_assignment_id    = azurerm_subscription_policy_assignment.baseline.id
  resource_discovery_mode = "ReEvaluateCompliance"
  failure_percentage      = 10
  parallel_deployments    = 5
  resource_count          = 500
}

resource "azurerm_subscription_policy_remediation" "require_https_storage" {
  count                   = var.enforce_policies ? 1 : 0
  name                    = "remediation-require-https-storage"
  subscription_id         = data.azurerm_subscription.current.id
  policy_assignment_id    = azurerm_subscription_policy_assignment.baseline.id
  resource_discovery_mode = "ReEvaluateCompliance"
  failure_percentage      = 5
  parallel_deployments    = 3
  resource_count          = 200
}
