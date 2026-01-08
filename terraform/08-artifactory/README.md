# Nexus OSS Artifactory Module (08-artifactory)

## Overview

Production-ready deployment of Nexus OSS 3.x on Azure Container Instances with persistent storage via Azure Files.

## Architecture

- **Azure Container Instance**: 2 vCPU, 4 GB RAM
- **Azure Files**: 100 GB persistent storage for `/nexus-data`
- **Azure Container Registry**: Store custom Nexus images
- **Managed Identity**: Secure ACR authentication
- **Cost Monitoring**: $50/month budget with alerts

## Prerequisites

- Terraform >= 1.0
- Azure CLI authenticated
- Resource group: `azure-platform-dev-rg` (or your environment)
- Terraform state storage configured

## Deployment

```bash
cd terraform/08-artifactory
./deploy.sh dev.tfvars
```

## First-Time Setup

### 1. Retrieve Admin Password

Nexus auto-generates an admin password on first startup:

```bash
az container logs --name ci-nexus-dev --resource-group azure-platform-dev-rg 2>&1 | grep -i password
```

### 2. Access Nexus UI

Navigate to the Nexus URL from terraform outputs:

```bash
terraform output nexus_url
```

Login with:
- **Username**: `admin`
- **Password**: (from container logs)

### 3. Complete Setup Wizard

- Change admin password
- Configure anonymous access (disable for security)
- Create repositories (Maven, Docker, npm, PyPI, etc.)

## Monitoring

Enable monitoring in the observability module:

```hcl
# In terraform/05-observability/dev.tfvars
enable_artifactory_monitoring = true
```

Then deploy observability module:

```bash
cd terraform/05-observability
./deploy.sh dev.tfvars
```

## Backup

Azure Files snapshots can be configured for daily backups:

```bash
# Create manual snapshot
az storage share snapshot \
  --account-name <storage_account_name> \
  --name nexus-data
```

## Cost

Estimated cost for development environment: **~$47.50/month**

- Azure Container Instance: ~$35
- Azure Files (100 GB): ~$5
- Storage Account: ~$0.50
- Container Registry: ~$5
- Data Transfer: ~$2

## Troubleshooting

### Container Not Starting

```bash
# Check container logs
az container logs --name ci-nexus-dev --resource-group azure-platform-dev-rg

# Common issues:
# - Insufficient memory: Increase container_memory in dev.tfvars
# - Volume mount failure: Verify storage account key
# - Image pull failure: Verify managed identity has AcrPull role
```

### Health Probe Failing

Increase `initial_delay_seconds` if Nexus startup is slow (default: 300 seconds).

### Out of Disk Space

Increase `file_share_quota` in `dev.tfvars` and redeploy.

## Support

For issues, see the troubleshooting guide in the implementation plan or refer to [Nexus Documentation](https://help.sonatype.com/repomanager3).
