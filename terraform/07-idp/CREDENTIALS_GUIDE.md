# Backstage Credentials Management Guide

This guide explains how to securely manage credentials for Backstage deployment and answer your specific question about configuring PostgreSQL credentials on-the-fly.

## Table of Contents
1. [Overview](#overview)
2. [Credential Flow](#credential-flow)
3. [Local Development](#local-development)
4. [CI/CD Deployment (GitHub Actions)](#cicd-deployment-github-actions)
5. [Manual Deployment](#manual-deployment)
6. [Security Best Practices](#security-best-practices)

---

## Overview

The Backstage deployment requires several credentials:
- **PostgreSQL**: Database password
- **GitHub**: Personal Access Token (PAT), OAuth Client ID/Secret
- **Azure AD**: Automatically generated client secret

### How Credentials Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  DEPLOYMENT WORKFLOW                         │
└─────────────────────────────────────────────────────────────┘

1. INFRASTRUCTURE DEPLOYMENT (Terraform)
   ├── Generate PostgreSQL password → Store in Terraform state
   ├── Create PostgreSQL server with credentials
   ├── Create Azure AD app → Auto-generate client secret
   ├── Create ACR → Enable managed identity auth
   └── Output: DB credentials, ACR URL, AD app details

2. BUILD BACKSTAGE IMAGE
   ├── Use outputs from step 1
   ├── Build Docker image with app-config.yaml
   └── Push to ACR (using managed identity)

3. DEPLOY BACKSTAGE CONTAINER
   ├── Pull image from ACR
   ├── Inject credentials as environment variables
   └── Container connects to PostgreSQL using injected credentials
```

---

## Credential Flow

### Question: "How would we configure credentials for postgres on the fly while deploying backstage infra and then building and deploying backstage application?"

**Answer**: The credentials flow through three stages:

### Stage 1: Infrastructure Deployment (Terraform Apply)

```bash
# Credentials are provided as Terraform variables
export TF_VAR_db_admin_password="$(openssl rand -base64 32)"
export TF_VAR_github_token="ghp_xxxxxxxxxxxx"
export TF_VAR_github_client_id="abc123"
export TF_VAR_github_client_secret="secret123"

# Deploy infrastructure
cd terraform/07-idp
terraform init -backend-config=backend.hcl
terraform apply -var-file=dev.tfvars

# Terraform outputs the credentials (stored in state)
terraform output postgresql_server_fqdn
terraform output -raw db_admin_password  # Sensitive, won't show by default
```

**What happens:**
1. Terraform creates PostgreSQL server with the password
2. Stores password in Terraform state (encrypted at rest in Azure Storage)
3. Outputs PostgreSQL FQDN and other connection details

### Stage 2: Build Backstage Image

```bash
# Get infrastructure outputs from Terraform
POSTGRES_HOST=$(terraform output -raw postgresql_server_fqdn)
POSTGRES_USER=$(terraform output -raw db_admin_username)
ACR_URL=$(terraform output -raw acr_login_server)

# Build Backstage image with configuration
docker build \
  --build-arg POSTGRES_HOST=$POSTGRES_HOST \
  --build-arg POSTGRES_USER=$POSTGRES_USER \
  -t $ACR_URL/backstage:latest \
  ./backstage

# Login to ACR using managed identity or service principal
az acr login --name $(terraform output -raw container_registry_name)

# Push image
docker push $ACR_URL/backstage:latest
```

### Stage 3: Deploy/Update Container

The container instance is **already deployed by Terraform** with credentials injected as environment variables:

```hcl
# In main.tf - Container receives credentials automatically
secure_environment_variables = {
  POSTGRES_PASSWORD    = var.db_admin_password  # From Terraform input
  GITHUB_TOKEN         = var.github_token
  GITHUB_CLIENT_ID     = var.github_client_id
  GITHUB_CLIENT_SECRET = var.github_client_secret
}
```

**Key Point**: The PostgreSQL password flows from:
1. Your secret store (GitHub Secrets/Azure Key Vault)
2. → Terraform variable (`TF_VAR_db_admin_password`)
3. → PostgreSQL server creation
4. → Container environment variables
5. → Backstage application connects to PostgreSQL

---

## Local Development

### Prerequisites
```bash
# Install required tools
az --version
terraform --version
docker --version
```

### Generate Secrets Locally

```bash
# Generate strong PostgreSQL password
export TF_VAR_db_admin_password="$(openssl rand -base64 32)"

# GitHub credentials (create at https://github.com/settings/developers)
export TF_VAR_github_token="ghp_YOUR_PAT_HERE"
export TF_VAR_github_client_id="your_oauth_client_id"
export TF_VAR_github_client_secret="your_oauth_secret"

# Optional: Save to .env file (DO NOT COMMIT)
cat > .env.local <<EOF
export TF_VAR_db_admin_password="${TF_VAR_db_admin_password}"
export TF_VAR_github_token="${TF_VAR_github_token}"
export TF_VAR_github_client_id="${TF_VAR_github_client_id}"
export TF_VAR_github_client_secret="${TF_VAR_github_client_secret}"
EOF

chmod 600 .env.local
echo ".env.local" >> .gitignore
```

### Deploy Infrastructure

```bash
# Source credentials
source .env.local

# Login to Azure
az login

# Deploy
cd terraform/07-idp
terraform init -backend-config=backend.hcl
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars

# Save outputs for later use
terraform output -json > outputs.json
```

---

## CI/CD Deployment (GitHub Actions)

### Step 1: Configure GitHub Secrets

In your repository settings → Secrets and variables → Actions:

```
TF_VAR_db_admin_password: <generated-password>
TF_VAR_github_token: ghp_xxxxx
TF_VAR_github_client_id: xxxxx
TF_VAR_github_client_secret: xxxxx
AZURE_CREDENTIALS: <service-principal-json>
```

### Step 2: GitHub Actions Workflow

```yaml
name: Deploy Backstage Infrastructure

on:
  push:
    branches: [main]
    paths:
      - 'terraform/07-idp/**'

env:
  TF_VAR_db_admin_password: ${{ secrets.TF_VAR_db_admin_password }}
  TF_VAR_github_token: ${{ secrets.TF_VAR_github_token }}
  TF_VAR_github_client_id: ${{ secrets.TF_VAR_github_client_id }}
  TF_VAR_github_client_secret: ${{ secrets.TF_VAR_github_client_secret }}

jobs:
  terraform:
    runs-on: ubuntu-latest
    outputs:
      acr_login_server: ${{ steps.tf_output.outputs.acr_login_server }}
      postgres_host: ${{ steps.tf_output.outputs.postgres_host }}

    steps:
      - uses: actions/checkout@v3

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Terraform Init
        working-directory: terraform/07-idp
        run: terraform init -backend-config=backend.hcl

      - name: Terraform Apply
        working-directory: terraform/07-idp
        run: terraform apply -auto-approve -var-file=dev.tfvars

      - name: Export Outputs
        id: tf_output
        working-directory: terraform/07-idp
        run: |
          echo "acr_login_server=$(terraform output -raw acr_login_server)" >> $GITHUB_OUTPUT
          echo "postgres_host=$(terraform output -raw postgresql_server_fqdn)" >> $GITHUB_OUTPUT

  build_and_deploy:
    needs: terraform
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Build and Push Backstage Image
        run: |
          ACR_URL="${{ needs.terraform.outputs.acr_login_server }}"

          # Login to ACR
          az acr login --name $(echo $ACR_URL | cut -d'.' -f1)

          # Build image
          docker build -t $ACR_URL/backstage:latest ./backstage

          # Push image
          docker push $ACR_URL/backstage:latest

      - name: Restart Container Instance
        run: |
          # Get container group name from Terraform output
          CONTAINER_GROUP=$(az container list --query "[?starts_with(name, 'ci-backstage')].name" -o tsv)
          RESOURCE_GROUP="rg-platform-dev-centralindia"

          # Restart to pick up new image
          az container restart --name $CONTAINER_GROUP --resource-group $RESOURCE_GROUP
```

---

## Manual Deployment

### Complete Deployment Script

Save as `deploy-backstage.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Configuration
ENVIRONMENT="${1:-dev}"
TFVARS_FILE="${ENVIRONMENT}.tfvars"

echo "🚀 Deploying Backstage to environment: $ENVIRONMENT"

# Step 1: Check prerequisites
echo "📋 Checking prerequisites..."
command -v az >/dev/null 2>&1 || { echo "Azure CLI required"; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Terraform required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }

# Step 2: Source credentials
if [ -f ".env.${ENVIRONMENT}" ]; then
  echo "🔐 Loading credentials from .env.${ENVIRONMENT}"
  source ".env.${ENVIRONMENT}"
else
  echo "⚠️  No .env.${ENVIRONMENT} file found"
  echo "Please set the following environment variables:"
  echo "  TF_VAR_db_admin_password"
  echo "  TF_VAR_github_token"
  echo "  TF_VAR_github_client_id"
  echo "  TF_VAR_github_client_secret"
  exit 1
fi

# Step 3: Deploy infrastructure
echo "🏗️  Deploying infrastructure with Terraform..."
cd terraform/07-idp

terraform init -backend-config=backend.hcl
terraform plan -var-file="${TFVARS_FILE}" -out=tfplan
terraform apply tfplan

# Step 4: Capture outputs
echo "📤 Capturing Terraform outputs..."
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
ACR_NAME=$(terraform output -raw container_registry_name)
POSTGRES_HOST=$(terraform output -raw postgresql_server_fqdn)
POSTGRES_USER="backstage_admin"
CONTAINER_FQDN=$(terraform output -raw container_fqdn)

echo "✅ Infrastructure deployed successfully"
echo "   ACR: $ACR_LOGIN_SERVER"
echo "   PostgreSQL: $POSTGRES_HOST"
echo "   Container URL: http://${CONTAINER_FQDN}:7007"

# Step 5: Build and push Backstage image
echo "🐳 Building Backstage Docker image..."
cd ../../backstage  # Adjust path to your Backstage app

# Login to ACR using managed identity
az acr login --name "$ACR_NAME"

# Build image
docker build -t "${ACR_LOGIN_SERVER}/backstage:latest" .

# Push image
echo "📦 Pushing image to ACR..."
docker push "${ACR_LOGIN_SERVER}/backstage:latest"

# Step 6: Restart container to pick up new image
echo "🔄 Restarting container instance..."
RESOURCE_GROUP="rg-platform-${ENVIRONMENT}-centralindia"
CONTAINER_GROUP="ci-backstage-${ENVIRONMENT}"

az container restart \
  --name "$CONTAINER_GROUP" \
  --resource-group "$RESOURCE_GROUP"

echo "⏳ Waiting for container to become healthy..."
sleep 30

# Step 7: Verify deployment
echo "🔍 Verifying deployment..."
BACKSTAGE_URL="http://${CONTAINER_FQDN}:7007"

if curl -sf "${BACKSTAGE_URL}/healthcheck" >/dev/null; then
  echo "✅ Backstage is healthy and running!"
  echo "🌐 Access Backstage at: $BACKSTAGE_URL"
else
  echo "⚠️  Backstage health check failed. Check container logs:"
  echo "   az container logs --name $CONTAINER_GROUP --resource-group $RESOURCE_GROUP"
fi

echo ""
echo "🎉 Deployment complete!"
```

Make it executable:
```bash
chmod +x deploy-backstage.sh
```

Run deployment:
```bash
./deploy-backstage.sh dev
```

---

## Security Best Practices

### ✅ DO

1. **Use Azure Key Vault for Production**
   ```bash
   # Store password in Key Vault
   az keyvault secret set \
     --vault-name "kv-platform-prod" \
     --name "backstage-db-password" \
     --value "$(openssl rand -base64 32)"

   # Retrieve during deployment
   export TF_VAR_db_admin_password=$(az keyvault secret show \
     --vault-name "kv-platform-prod" \
     --name "backstage-db-password" \
     --query value -o tsv)
   ```

2. **Rotate Credentials Regularly**
   ```bash
   # Update PostgreSQL password
   az postgres flexible-server update \
     --resource-group rg-platform-prod \
     --name psql-backstage-prod-001 \
     --admin-password "NEW_PASSWORD"

   # Update container environment variables
   az container create ... (with new password)
   ```

3. **Use Managed Identity for ACR**
   - Already configured in the updated Terraform code
   - No admin passwords needed for container registry

4. **Enable Terraform State Encryption**
   ```hcl
   # Already configured in backend.hcl
   # Terraform state is encrypted in Azure Storage
   ```

### ❌ DON'T

1. **Never commit secrets to Git**
   - Use `.gitignore` for `.env*` files
   - Use GitHub Secrets for CI/CD
   - Use Azure Key Vault for production

2. **Never use admin passwords in production**
   - Use Azure AD authentication for PostgreSQL (future enhancement)
   - Use managed identities wherever possible

3. **Never hardcode credentials**
   - Always use environment variables or secret stores
   - Already fixed in `core.tfvars`

---

## Troubleshooting

### Container can't connect to PostgreSQL

```bash
# Check firewall rules
az postgres flexible-server firewall-rule list \
  --resource-group rg-platform-dev-centralindia \
  --server-name psql-backstage-dev-001

# Check container IP
az container show \
  --name ci-backstage-dev \
  --resource-group rg-platform-dev-centralindia \
  --query ipAddress.ip
```

### ACR authentication fails

```bash
# Check role assignment
az role assignment list \
  --scope /subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.ContainerRegistry/registries/{acr-name} \
  --assignee {managed-identity-id}

# Verify managed identity
az identity show --id {managed-identity-id}
```

### View container logs

```bash
az container logs \
  --name ci-backstage-dev \
  --resource-group rg-platform-dev-centralindia \
  --follow
```

---

## Summary

**Answer to your question:**

PostgreSQL credentials are configured "on the fly" by:

1. **Generating password** → Environment variable or Azure Key Vault
2. **Terraform reads password** → `TF_VAR_db_admin_password`
3. **Terraform creates PostgreSQL** → With that password
4. **Terraform injects into container** → As secure environment variable
5. **Container starts** → Backstage connects using injected credentials

The key is that **Terraform acts as the orchestrator**, receiving credentials as inputs and distributing them to both:
- PostgreSQL server (during creation)
- Container instance (as environment variables)

This ensures the credentials match and flow seamlessly through the deployment pipeline.
