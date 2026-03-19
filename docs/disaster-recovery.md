# Disaster Recovery Runbook

## RTO and RPO Targets

| Environment | RTO | RPO |
|-------------|-----|-----|
| Production  | 1 hour | 15 minutes |
| Staging     | 4 hours | 1 hour |
| Dev         | 8 hours | 24 hours |

## Recovery Steps

### 1. Database Restore
```bash
az postgres flexible-server restore \
  --source-server <prod-server-id> \
  --name <restored-server-name> \
  --resource-group <rg> \
  --restore-time <point-in-time>
```

### 2. AKS Cluster Failover
- Traffic Manager automatically routes to secondary region
- ArgoCD re-deploys applications from Git source

### 3. Key Vault Access
- Managed identity authentication continues via Azure AD
- No manual secret rotation required for failover

## Runbook Testing
DR tests are run quarterly using chaos scripts in `scripts/chaos/`.
