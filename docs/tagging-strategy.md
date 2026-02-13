# Resource Tagging Strategy

All Azure resources managed by this suite carry a consistent set of tags enforced via `locals.common_tags` in each module.

## Required tags

| Tag | Description | Example |
|-----|-------------|---------|
| `Environment` | Deployment environment | `dev`, `staging`, `production` |
| `Project` | Top-level project name | `azure-platform` |
| `ManagedBy` | Provisioning tool | `terraform` |
| `Component` | Module that owns the resource | `networking`, `aks` |
| `CostCenter` | Finance cost allocation unit | `engineering` |
| `Repository` | Source repository | `azure-automation-suite` |

## Optional tags (production only)

| Tag | Description |
|-----|-------------|
| `Compliance` | Compliance scope indicator (`required`) |
| `DataClassification` | Data sensitivity level (`public`, `internal`, `confidential`) |
| `SLA` | Uptime SLA tier (`99.9`, `99.99`) |

## Enforcement

Tags are enforced via the Azure Policy assignment in `terraform/09-governance/`.
The `require-tags` policy denies resource creation if `Environment`, `Project`, or `ManagedBy` are missing.
