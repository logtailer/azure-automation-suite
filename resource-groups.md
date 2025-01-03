# Resource Group Strategy for Azure Platform

## Overview

This document outlines the recommended approach for organizing Azure Resource Groups (RGs) across all platform components and environments.

---

## Resource Group Structure

| Component        | Resource Group Example         | Scope         | Description                                      |
|------------------|-------------------------------|---------------|--------------------------------------------------|
| Networking       | rg-networking-dev             | Per env       | VNets, subnets, NAT gateways, NSGs, etc.         |
| AKS Runners      | rg-aks-runners                | Shared/global | AKS cluster for GitHub Actions runners           |
| CI/CD            | rg-cicd-dev                   | Per env       | CI/CD infra (runners, pipelines, etc.)           |
| Security Stack   | rg-security-dev               | Per env       | Key Vault, policies, security monitoring, etc.   |
| Nexus OSS        | rg-nexus                      | Shared/global | Artifact repository (Nexus)                      |
| Vault            | rg-vault                      | Shared/global | HashiCorp Vault cluster                          |
| App Workloads    | rg-app1-dev                   | Per env/app   | Application-specific resources                   |

---

## Rationale

- **Separation of concerns:** Simplifies management, security, and cost tracking.
- **Scalability:** Easily add/remove environments or components.
- **Access control:** Assign RBAC at the RG level for teams/components.
- **Disaster recovery:** Restore or re-create only the affected RG/component.

---

## Terraform Implementation

- Each component’s Terraform code defines its own resource group.
- Resource group names are passed as variables (from tfvars) for each environment.
- Shared/global components use a fixed RG name.

---

## Example

```hcl
resource "azurerm_resource_group" "networking" {
  name     = var.networking_rg_name
  location = var.location
}
```

---

**Follow this pattern for all components to ensure a clean, scalable, and secure Azure environment.**