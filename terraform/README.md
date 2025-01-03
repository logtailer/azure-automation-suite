# Azure Platform Infrastructure

This repository contains Terraform infrastructure code for a comprehensive Azure cloud platform, including CI/CD, observability, security, and application hosting capabilities.

## Architecture Overview

The platform consists of the following components:

- **Core Infrastructure**: VNet, subnets, NAT Gateway, NSGs
- **Identity**: Azure AD/Entra ID integration
- **Container Orchestration**: Azure Kubernetes Service (AKS)
- **Artifact Management**: Azure Container Registry (ACR)
- **Security**: Azure Key Vault, RBAC, Azure Policy
- **Observability**: Prometheus, Grafana, Loki (deployed on AKS)
- **CI/CD**: GitHub Actions + ArgoCD
- **Developer Platform**: Backstage (Internal Developer Platform)

## Folder Structure

```
terraform/
├── backend/                    # Terraform state backend setup
├── core/                      # Core networking infrastructure
├── identity/                  # Identity provider configuration
├── cicd/                      # CI/CD infrastructure
├── artifact/                  # Container registry and artifact storage
├── observability/             # Monitoring and logging
├── developer-platform/        # Internal developer platform
├── aks/                       # Kubernetes cluster
├── security/                  # Security and governance
├── data/                      # Databases and data services
├── app/                       # Application deployment
├── modules/                   # Reusable Terraform modules
└── environments/              # Environment-specific configurations
    ├── dev/
    └── prod/
```

## Getting Started

### Prerequisites

1. Azure CLI installed and authenticated
2. Terraform >= 1.0
3. kubectl (for AKS management)

### Deployment Steps

1. **Deploy Backend Infrastructure**:
   ```bash
   cd backend
   terraform init
   terraform apply
   ```
   Note the storage account name and resource group for use in subsequent steps.

2. **Configure Backend for Other Components**:
   Update `backend.tfvars` in each component with the backend storage details.

3. **Deploy Core Infrastructure**:
   ```bash
   cd core
   terraform init -backend-config=../backend/backend.tfvars
   terraform apply
   ```

4. **Deploy Security Infrastructure**:
   ```bash
   cd security
   terraform init -backend-config=../backend/backend.tfvars
   terraform apply
   ```

5. **Deploy Artifact Repository**:
   ```bash
   cd artifact
   terraform init -backend-config=../backend/backend.tfvars
   terraform apply
   ```

6. **Deploy AKS Cluster**:
   ```bash
   cd aks
   terraform init -backend-config=../backend/backend.tfvars
   terraform apply
   ```

### Environment Management

Use the `environments/` folder for orchestrating multiple components:

```bash
cd environments/dev
terraform init -backend-config=../../backend/backend.tfvars
terraform apply
```

## Network Design

The platform uses a hub-and-spoke network architecture:

- **VNet**: 10.0.0.0/16
- **AKS Subnet**: 10.0.1.0/24
- **CI/CD Subnet**: 10.0.2.0/24
- **Observability Subnet**: 10.0.3.0/24
- **Security Subnet**: 10.0.4.0/24
- **Data Subnet**: 10.0.5.0/24

All subnets use a NAT Gateway for secure outbound internet access.

## Security Features

- Azure Key Vault for secrets management
- Network Security Groups (NSGs) for traffic control
- Azure Policy for compliance
- Azure Security Center integration
- Private endpoints for secure service access

## Observability Stack

The observability stack will be deployed on AKS and includes:
- Prometheus for metrics collection
- Grafana for visualization
- Loki for log aggregation
- Promtail for log collection

## CI/CD Pipeline

The platform supports:
- GitHub Actions for CI
- ArgoCD for GitOps-based CD
- Azure Container Registry for container images
- Automated security scanning

## Cost Optimization

- Uses Standard SKU resources where possible
- Auto-scaling enabled for AKS
- Retention policies for logs and artifacts
- Resource tagging for cost tracking

## Contributing

1. Follow the established folder structure
2. Use consistent naming conventions
3. Include proper variable descriptions
4. Add appropriate tags to all resources
5. Test in dev environment before promoting

## Support

For questions or issues:
1. Check the documentation in each component folder
2. Review the Terraform plan output
3. Ensure all prerequisites are met
4. Verify Azure permissions

## Next Steps

After deploying the infrastructure:
1. Configure kubectl for AKS access
2. Deploy observability stack using Helm
3. Set up ArgoCD in the cluster
4. Configure GitHub Actions workflows
5. Deploy your applications
