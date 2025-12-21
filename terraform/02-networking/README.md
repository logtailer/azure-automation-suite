# Networking Module

This module creates the core networking infrastructure for the Azure DevOps platform, including:

- Virtual Network (VNet) with multiple subnets
- Public subnet for load balancers and ingress
- Private subnet for backend services
- AKS-dedicated subnet for Kubernetes cluster
- NAT Gateway for secure outbound connectivity
- Network Security Groups (NSGs) for traffic control

## Architecture

```
Azure DevOps Platform VNet (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24)
│   ├── Application Gateway
│   └── Load Balancers
├── Private Subnet (10.0.2.0/24)
│   ├── Private endpoints
│   └── Backend services
└── AKS Subnet (10.0.10.0/23)
    └── Kubernetes cluster nodes
```

## Usage

### Prerequisites
1. Foundation module must be deployed first
2. Terraform backend must be configured
3. Azure CLI authentication required

### Deployment

```bash
# Navigate to networking module
cd terraform/02-networking

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="../environments/dev/terraform.tfvars"

# Apply configuration
terraform apply -var-file="../environments/dev/terraform.tfvars"
```

### Required Variables

Create a `terraform.tfvars` file with these values:

```hcl
# Backend configuration
backend_resource_group_name  = "your-terraform-rg"
backend_storage_account_name = "yourtfstatestorage"

# Project configuration
environment  = "dev"


# Network configuration
vnet_name          = "devops-platform-vnet"
vnet_address_space = "10.0.0.0/16"

# Subnet configuration
public_subnet_name  = "public-subnet"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_name = "private-subnet"
private_subnet_cidr = "10.0.2.0/24"
aks_subnet_name     = "aks-subnet"
aks_subnet_cidr     = "10.0.10.0/23"
```

## Resources Created

### Core Networking
- **Virtual Network**: Main network container
- **Public Subnet**: Internet-facing resources
- **Private Subnet**: Internal resources with NAT Gateway
- **AKS Subnet**: Dedicated subnet for Kubernetes

### Security
- **NAT Gateway**: Secure outbound internet access
- **Public NSG**: HTTP/HTTPS traffic allowed
- **Private NSG**: VNet-only traffic allowed

### Outputs
- VNet ID and configuration details
- Subnet IDs for other modules to reference
- NAT Gateway public IP
- NSG IDs for additional rule configuration

## Dependencies

### Inputs (from foundation module)
- Resource group name and location
- Common tags and naming conventions

### Outputs (for other modules)
- AKS subnet ID → 04-aks module
- Private subnet ID → 03-security module
- VNet ID → Multiple modules

## Cost Optimization

- **NAT Gateway**: ~$45/month per gateway
- **Public IP**: ~$3.65/month per static IP
- **NSG**: Free with Azure subscription

## Security Features

- **Zero Trust**: Default deny, explicit allow rules
- **Subnet Isolation**: Separate subnets for different tiers
- **NAT Gateway**: No direct public IP on private resources
- **NSG Rules**: Least privilege access patterns

## Next Steps

After deploying networking:
1. Deploy security module (03-security)
2. Configure private endpoints
3. Deploy AKS cluster (04-aks)
4. Set up monitoring (05-observability)
