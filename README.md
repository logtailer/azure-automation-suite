[![Terraform Verify](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml/badge.svg)](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml)

# Azure Automation Suite

> **Enterprise-grade Azure DevOps platform built with Terraform, featuring modular infrastructure, automated deployments, and comprehensive monitoring.**

## 🚀 Quick Start

```bash
# Clone and navigate
git clone https://github.com/logtailer/azure-automation-suite.git
cd azure-automation-suite/terraform

# Deploy foundation layer
cd 01-foundation
./deploy.sh core.tfvars

# Deploy networking layer  
cd ../02-networking/application-network
./deploy.sh dev.tfvars

# Deploy AKS cluster
cd ../../04-aks
./deploy.sh core.tfvars
```

## 🏗️ Architecture

This project implements a **production-ready Azure platform** with:

- **🔧 Modular Infrastructure**: Sequential deployment layers (foundation → networking → security → compute)
- **🚀 Kubernetes Platform**: Production AKS with multi-subnet node pools and Azure Bastion access
- **🔐 Security First**: Zero-trust networking, service principal authentication, private endpoints
- **📊 Observability Ready**: Structured for comprehensive monitoring and logging
- **🔄 GitOps Ready**: CI/CD pipelines with Terraform validation and automated deployments

## 📁 Project Structure

```
terraform/
├── 01-foundation/      # Resource groups, storage accounts, core infra
├── 02-networking/      # VNets, subnets, NSGs, NAT Gateway  
├── 03-security/        # Key Vault, RBAC, security policies
├── 04-aks/            # AKS clusters, node pools, Bastion host
├── 05-observability/   # Monitoring, alerting, dashboards
├── 06-cicd/           # CI/CD infrastructure, build agents
└── 07-idp/            # Identity provider integration
```

## 🛠️ Prerequisites

- **Azure CLI** with valid subscription
- **Terraform** >= 1.6.0
- **Service Principal** with Contributor + Storage Blob Data Contributor roles
- **Azure Storage Account** for remote state management

## 🔧 Configuration

Each module contains:
- `deploy.sh` - Automated deployment script with error handling
- `backend.hcl` - Remote state configuration
- `core.tfvars` - Environment-agnostic variables
- `.env` - Service principal credentials (gitignored)

## 📈 Features

### Infrastructure
- ✅ **Multi-region ready** with configurable locations
- ✅ **Auto-scaling AKS** with system and user node pools
- ✅ **Secure networking** with private/public subnet separation
- ✅ **State isolation** per module for parallel development

### DevOps
- ✅ **GitHub Actions** for Terraform validation
- ✅ **Automated testing** with format and validation checks
- ✅ **Robust deployment** scripts with backend migration handling
- ✅ **Environment promotion** with variable file separation

### Security
- ✅ **Service Principal** authentication
- ✅ **Network Security Groups** with least-privilege rules
- ✅ **Azure Bastion** for secure VM access
- ✅ **Private endpoints** for storage and key vault access

## 🎯 Roadmap

- [ ] Complete security module (Key Vault, RBAC policies)
- [ ] Implement observability stack (Prometheus, Grafana)
- [ ] Add CI/CD module (Azure DevOps, GitHub Actions runners)
- [ ] Integrate identity provider (Azure AD, OIDC)
- [ ] Add application deployment examples
- [ ] Implement disaster recovery and backup strategies

## 📚 Documentation

- [Architecture Guide](docs/architecture.md) - Detailed system design and decisions
- [Deployment Guide](docs/deployment-guide.md) - Step-by-step deployment instructions
- [Module Organization](terraform/ORGANIZATION.md) - Infrastructure module breakdown

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-module`
3. Make changes and test with `terraform validate`
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ for enterprise Azure platform engineering**