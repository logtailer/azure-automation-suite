# Enterprise Security Module Guide

## Overview
Comprehensive enterprise-grade security infrastructure providing identity management, access control, network security, governance, and audit logging.

## Features

### Identity & Access Management
- **4 Managed Identities**: AKS workload, App workload, DevOps automation, Monitoring
- **RBAC Integration**: Role assignments for Key Vault and resource access
- **Least Privilege**: Secrets User for apps, Administrator for DevOps

### Secrets Management
- **Azure Key Vault**: Standard/Premium SKU with enterprise configuration
- **Purge Protection**: 90-day soft delete retention (default)
- **RBAC Authorization**: Role-based access control enabled
- **Network Security**: Default deny with IP whitelisting

### Network Security
- **NSG**: Network security group with HTTPS allow rules
- **Private Endpoints**: Optional VNet integration for Key Vault
- **IP Whitelisting**: Configurable allowed IP ranges
- **Default Deny**: Secure by default network posture

### Governance & Compliance
- **Resource Locks**: Prevent accidental deletion (CanNotDelete/ReadOnly)
- **Azure Policy**: 6 built-in policies for compliance
  - Require tags on resources
  - Require HTTPS for storage
  - Audit Key Vaults without purge protection
  - Azure Defender for Key Vault
  - Block public network access to Key Vault

### Audit & Monitoring
- **Diagnostic Logging**: AuditEvent and PolicyEvaluation categories
- **3 Key Vault Alerts**:
  - Availability (<99%)
  - Capacity saturation (>75%)
  - Failed requests (>10)
- **Log Analytics Integration**: Centralized audit trail

### Cost Management
- **Budget Tracking**: $10/month default with 80% threshold
- **Cost Alerts**: Email notifications at threshold

## Quick Start

### Deployment
```bash
cd terraform/03-security
./deploy.sh production.tfvars
```

### Configuration
Required variables in tfvars:
```hcl
resource_group_name = "rg-security"
key_vault_name      = "kv-platform-security-001"

# Enable identities
enable_aks_identity        = true
enable_app_identity        = true
enable_devops_identity     = true
enable_monitoring_identity = true

# Network security
default_network_action = "Deny"
allowed_ip_ranges      = ["your.ip.address/32"]

# Governance
enable_resource_locks = true
lock_level            = "CanNotDelete"
```

## Security Best Practices

### Key Vault Configuration
1. **Enable Purge Protection**: Prevents permanent deletion
   ```hcl
   purge_protection_enabled = true
   soft_delete_retention_days = 90
   ```

2. **Network Restrictions**: Default deny with whitelisting
   ```hcl
   default_network_action = "Deny"
   allowed_ip_ranges      = ["10.0.0.0/8"]
   ```

3. **RBAC Authorization**: Use managed identities
   ```hcl
   enable_rbac_authorization = true
   ```

### Identity Management
Use managed identities for workload authentication:
```hcl
# Reference in other modules
data "terraform_remote_state" "security" {
  # ...
}

identity {
  type = "UserAssigned"
  identity_ids = [
    data.terraform_remote_state.security.outputs.aks_workload_identity_id
  ]
}
```

### Network Security
Enable private endpoints when VNet is available:
```hcl
enable_private_endpoint = true
subnet_id               = data.azurerm_subnet.security.id
vnet_id                 = data.azurerm_virtual_network.main.id
```

## Integration

### With Observability Module
```hcl
# In core.tfvars
log_analytics_workspace_id = data.terraform_remote_state.observability.outputs.log_analytics_workspace_id
action_group_id            = data.terraform_remote_state.observability.outputs.action_group_id
```

### With AKS Module
```hcl
# Reference managed identity
kubelet_identity {
  identity_id = data.terraform_remote_state.security.outputs.aks_workload_identity_id
}
```

## Compliance

### Azure Policy Compliance
- ✅ CIS Microsoft Azure Foundations Benchmark
- ✅ Azure Security Benchmark
- ✅ NIST SP 800-53
- ✅ ISO 27001

### Audit Requirements
All Key Vault operations logged to Log Analytics:
- Secret access (Get, List, Set, Delete)
- Key operations
- Certificate management
- Policy changes

## Troubleshooting

### Access Denied to Key Vault
```bash
# Verify RBAC assignment
az role assignment list --scope <key-vault-id>

# Check network ACLs
az keyvault network-rule list --name <vault-name>
```

### Private Endpoint Not Working
```bash
# Verify DNS resolution
nslookup <vault-name>.vault.azure.net

# Check private endpoint connection
az network private-endpoint show --name pe-keyvault-production
```

## Cost Optimization
- Key Vault: $0.03/10,000 operations
- Managed Identities: Free
- Resource Locks: Free
- Azure Policy: Free (built-in)
- Diagnostic Logs: Pay for Log Analytics ingestion (~$2.50/GB)

**Estimated monthly cost**: $10-15

## References
- [Azure Key Vault Best Practices](https://docs.microsoft.com/en-us/azure/key-vault/general/best-practices)
- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)
- [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)
