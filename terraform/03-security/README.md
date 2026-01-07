# 03-Security Module

## Overview
Enterprise-grade security infrastructure providing centralized identity management, secrets storage, network security, governance, and audit logging for the Azure platform.

## Features

### Core Security
- Azure Key Vault (Standard/Premium)
- 4 Managed Identities (AKS, App, DevOps, Monitoring)
- RBAC role assignments
- Network Security Groups

### Governance
- Resource locks (CanNotDelete/ReadOnly)
- 6 Azure Policy assignments
- Tag enforcement
- Compliance monitoring

### Monitoring
- Key Vault diagnostic logging
- 3 availability/performance alerts
- Log Analytics integration
- Audit trail

## Quick Start

```bash
cd terraform/03-security
./deploy.sh production.tfvars
```

## Configuration

### Required Variables
- `resource_group_name`: Security resource group
- `key_vault_name`: Unique Key Vault name

### Optional Features
```hcl
enable_aks_identity        = true  # Managed identity for AKS
enable_private_endpoint    = false # Key Vault private endpoint
enable_resource_locks      = true  # Prevent deletion
enable_audit_logging       = true  # Diagnostic logs
enable_component_budget    = true  # Cost tracking
```

## Security Best Practices
- Enable purge protection (90-day retention)
- Use default deny for network ACLs
- Enable RBAC authorization
- Configure audit logging
- Set resource locks

## Outputs
- `key_vault_id`: Key Vault resource ID
- `aks_workload_identity_id`: Managed identity for AKS
- `app_workload_identity_id`: Managed identity for apps
- `security_nsg_id`: Network security group ID

## Documentation
- [Security Guide](SECURITY_GUIDE.md) - Comprehensive configuration guide
- [Foundation Module](../01-foundation/) - Base infrastructure
- [Observability Module](../05-observability/) - Monitoring integration

## Cost
**Estimated**: $10-15/month
- Key Vault: $0.03/10,000 operations
- Managed Identities: Free
- Diagnostic Logs: ~$2.50/GB

## Compliance
- CIS Azure Foundations Benchmark
- Azure Security Benchmark
- NIST SP 800-53
- ISO 27001
