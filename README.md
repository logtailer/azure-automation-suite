[![Terraform Verify](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml/badge.svg)](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml)
[![Security Scan](https://github.com/logtailer/azure-automation-suite/actions/workflows/security-scan.yml/badge.svg)](https://github.com/logtailer/azure-automation-suite/actions/workflows/security-scan.yml)

# Azure Platform Engineering Suite

A production-ready Azure infrastructure platform built with Terraform, covering the full stack from networking to developer tooling. Designed for a single-operator workflow on an Azure Student subscription (~$100 credits).

## Architecture

15 modules deploy in dependency order, each managing a distinct layer:

```
01-foundation      Resource groups, storage, ACR, core services
02-networking      VNet, subnets, NSGs, private DNS, flow logs
03-security        Key Vault, RBAC, managed identities, Defender
04-aks             Kubernetes cluster, node pools, autoscaler, Bastion
05-observability   Log Analytics, App Insights, Grafana, alerts
06-cicd            ARC runners, ArgoCD, GitHub Actions integration
07-idp             Backstage developer portal + PostgreSQL backend
08-artifactory     Nexus repository manager on Container Instances
09-governance      Azure Policy assignments and compliance controls
10-cost-management Subscription and resource group budgets
11-backup          Recovery Services Vault, VM and file share policies
12-appgateway      Application Gateway with WAF
13-traffic-manager Multi-region failover and health probing
14-database        PostgreSQL Flexible Server, MySQL, Redis Cache
15-policy          Custom policy definitions and initiative assignments
```

## Quick Start — Weekly Test Cycle

Set credentials once in a `.env` file at the repo root (gitignored):

```bash
ARM_CLIENT_ID=<service-principal-app-id>
ARM_CLIENT_SECRET=<service-principal-secret>
ARM_SUBSCRIPTION_ID=<your-subscription-id>
ARM_TENANT_ID=<your-tenant-id>
```

Then deploy, test, and destroy:

```bash
# Deploy all 15 modules in order (~30–60 min, ~$1–2/hour)
./scripts/deploy-all.sh --auto-approve

# ... explore, learn, test ...

# Tear everything down to preserve credits
./scripts/destroy-all.sh --auto-approve
```

All modules use `dev-minimal.tfvars` — pre-configured with the cheapest SKUs, expensive features (Firewall, VPN Gateway, Defender, NAT Gateway) disabled, and budgets set conservatively for a $100 student subscription.

## First-Time Setup

**1. Bootstrap remote state** (run once before anything else):

```bash
cd terraform/01-foundation
bash bootstrap.sh dev
```

This creates the Azure Storage Account used for all Terraform state.

**2. Set GitHub secrets** for CI/CD workflows:

| Secret | Value |
|---|---|
| `ARM_CLIENT_ID` | Service principal app ID |
| `ARM_CLIENT_SECRET` | Service principal secret |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure tenant ID |
| `TF_STATE_STORAGE_ACCOUNT` | `sumittfstatestorage` |
| `TF_STATE_RESOURCE_GROUP` | `terraform-state-rg` |

**3. Replace placeholder values** across all `dev-minimal.tfvars`:

```bash
./configure.sh
```

This interactive script patches every tfvars file in one pass (location, emails, credentials, passwords, SSH key). Alternatively, edit manually:

- `06-cicd`: `github_token`, `github_webhook_secret`, `github_repository_owner`
- `07-idp`: `github_token`, `github_client_id`, `github_client_secret`, `db_admin_password`
- `09-governance`: `subscription_id`
- `14-database`: `postgresql_admin_password`

## Local Development Setup

After cloning, run once to enable shared git hooks:

```bash
git config core.hooksPath scripts/hooks
pip install pre-commit && pre-commit install
```

The hooks provide:
- **pre-commit** — `terraform fmt`, `terraform validate`, Trivy (CRITICAL/HIGH only), Checkov, shellcheck, yamllint
- **pre-push** — auto-rebases on the remote branch if it has moved; exits with a message to re-run `git push` so the push succeeds cleanly

## Module Deployment (individual)

Each module has its own `deploy.sh` if you want to deploy a single layer:

```bash
cd terraform/04-aks
./deploy.sh dev-minimal.tfvars
```

## Cost Profile (dev-minimal)

| Resource | Monthly est. | Notes |
|---|---|---|
| VNet, NSGs, subnets | Free | |
| Storage (state + logs) | ~$1 | LRS |
| Key Vault | ~$0.50 | |
| ACR Basic | ~$5 | |
| Log Analytics | ~$1–3 | 14-day retention, low ingestion |
| App Insights | ~$0.50 | 5% sampling |
| AKS (2× B2s nodes) | ~$3/day | Spin up, use, destroy |
| PostgreSQL B1ms | ~$12/month | Burstable |

**Total for a 2-hour weekly session:** ~$1–2. Budget alerts fire at 50%, 80%, 100% of $20/month.

## Prerequisites

- Azure CLI ≥ 2.55
- Terraform ≥ 1.6
- Service principal with Contributor + Storage Blob Data Contributor roles

## Repository Structure

```
.
 scripts/
    deploy-all.sh       # Deploy all modules in order
    destroy-all.sh      # Destroy in reverse order
    hooks/              # Shared git hooks (pre-commit, pre-push)
 terraform/
    01-foundation/ … 15-policy/
    ORGANIZATION.md     # Module dependency notes
 .github/workflows/      # CI: validate, security scan, drift detection
```
