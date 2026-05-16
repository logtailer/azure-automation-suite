resource "azurerm_security_center_server_vulnerability_assessment_virtual_machine" "jit" {
  count              = var.enable_jit_access ? 1 : 0
  virtual_machine_id = var.jit_target_vm_id
}

resource "azapi_resource" "jit_policy" {
  count     = var.enable_jit_access ? 1 : 0
  type      = "Microsoft.Security/locations/jitNetworkAccessPolicies@2020-01-01"
  name      = "jit-policy-platform"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Security/locations/${var.location}"

  body = jsonencode({
    kind = "Basic"
    properties = {
      virtualMachines = [
        {
          id = var.jit_target_vm_id
          ports = [
            {
              number                     = 22
              protocol                   = "TCP"
              allowedSourceAddressPrefix = "*"
              maxRequestAccessDuration   = "PT3H"
            },
            {
              number                     = 3389
              protocol                   = "TCP"
              allowedSourceAddressPrefix = "*"
              maxRequestAccessDuration   = "PT3H"
            }
          ]
        }
      ]
    }
  })
}
