[![Terraform Verify](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml/badge.svg)](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml)

# 🚀 Azure Platform Engineering Suite

[![Terraform Verify](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml/badge.svg)](https://github.com/logtailer/azure-automation-suite/actions/workflows/terraform-verify.yml)

A production-ready, enterprise-grade Azure infrastructure platform built with modern DevOps and Platform Engineering principles.

## 🏗️ Platform Architecture

This platform implements a comprehensive **Internal Developer Platform (IDP)** that provides:
- **Self-Service Infrastructure** via Backstage portal
- **GitOps Deployments** with monitoring and alerting
- **Zero-Trust Security** with private networking  
- **Scalable Kubernetes** with AKS and auto-scaling

### 📐 Infrastructure Layers

```
13-Traffic-Manager → Multi-region failover + Health monitoring
12-AppGateway     → Application Gateway + WAF v2
11-Backup         → Recovery Services Vault + Backup policies
10-Cost-Mgmt      → Budget alerts + Cost monitoring
09-Governance     → Azure Policy + Compliance controls
08-Artifactory    → JFrog Artifactory + Storage
07-IDP            → Backstage Developer Portal + PostgreSQL
06-CI/CD          → Container Registry + Build Agents + Artifacts
05-Observability  → Log Analytics + App Insights + Dashboards
04-AKS            → Kubernetes Cluster + Node Pools + Bastion
03-Security       → Key Vault + Certificates + RBAC Policies
02-Networking     → VNet + Private DNS + Private Endpoints
01-Foundation     → Resource Groups + Storage + Core Infrastructure
```

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
├── 02-networking/      # VNets, subnets, NSGs, Private DNS zones
├── 03-security/        # Key Vault, certificates, RBAC policies
├── 04-aks/            # AKS clusters, node pools, Bastion host
├── 05-observability/   # Monitoring, alerting, dashboards
├── 06-cicd/           # CI/CD infrastructure, build agents
├── 07-idp/            # Backstage IDP integration
├── 08-artifactory/    # JFrog Artifactory setup
├── 09-governance/     # Azure Policy assignments
├── 10-cost-management/# Budgets and cost alerts
├── 11-backup/         # Recovery Services Vault
├── 12-appgateway/     # Application Gateway with WAF
└── 13-traffic-manager/# Multi-region traffic routing
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