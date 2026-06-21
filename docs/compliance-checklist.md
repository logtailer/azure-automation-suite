# Compliance Checklist

## SOC 2 Type II Readiness

### CC6 — Logical and Physical Access Controls
- [x] Azure AD RBAC enforced across all modules
- [x] Key Vault with RBAC authorization enabled
- [x] Private endpoints for production databases
- [x] Network Security Groups on all subnets
- [x] Azure Bastion for jump-host access (no public SSH)

### CC7 — System Operations
- [x] Log Analytics workspace with 90-day retention (prod)
- [x] Azure Monitor alerts for critical thresholds
- [x] Grafana dashboards for real-time visibility
- [x] Application Insights for application telemetry

### CC8 — Change Management
- [x] All infrastructure changes via Terraform (IaC)
- [x] PR-based workflow with plan output review
- [x] Multi-environment promotion (dev → staging → prod)
- [x] Automated security scanning on every PR (tfsec, Checkov)

### CC9 — Risk Mitigation
- [x] Azure Policy enforcement for baseline security
- [x] Defender for Cloud enabled (Standard tier, prod)
- [x] Key Vault purge protection enabled
- [x] Geo-redundant backup for production databases

## GDPR Readiness

| Requirement | Implementation | Status |
|-------------|---------------|--------|
| Data at rest encryption | Azure managed keys (storage, Key Vault) |  |
| Data in transit encryption | HTTPS-only policy enforced |  |
| Data classification tagging | `DataClassification` tag on all resources |  |
| Right to erasure | Soft-delete + configurable retention |  |
| Audit logging | Azure Monitor + Log Analytics |  |
| Data residency | `allowed_locations` policy restricts to approved regions |  |
