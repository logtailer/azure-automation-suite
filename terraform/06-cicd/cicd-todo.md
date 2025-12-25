# CI/CD Infrastructure TODOs

## CI/CD Stack Overview & Recommendations

### Self-hosted Runners
- Use AKS (Azure Kubernetes Service) for scalable, ephemeral GitHub Actions runners.
- Deploy actions-runner-controller or similar to manage runner pods per workflow/job.
- AKS allows auto-scaling, isolation, and secure networking for runners.
- For simple/low-concurrency needs, Azure Container Instances (ACI) is an alternative, but AKS is preferred for production.

### Nexus OSS (Artifact Repository)
- Deploy on a dedicated VM (or VMSS for high availability) with sufficient CPU/RAM.
- Attach multiple managed SSD disks in RAID (RAID 10 recommended for performance and redundancy).
- Secure with NSG/firewall, use private endpoints if possible.
- Regularly back up Nexus data (disk snapshots or external backup).
- For HA, consider running Nexus in AKS with persistent storage.

### HashiCorp Vault (Secrets Management)
- Deploy on dedicated VMs (start with 1, plan for 3+ for HA).
- Use managed disks for storage backend; RAID optional for performance/redundancy.
- Enable auto-unseal with Azure Key Vault or HSM for production.
- Secure with NSG/firewall, private endpoints, and TLS.
- Regularly back up Vault data and enable monitoring.

### Networking & Security
- Place all components in a secure VNet with subnets for runners, Nexus, and Vault.
- Use NSGs to restrict access (e.g., only allow GitHub IPs or office IP for Nexus).
- Use Azure Private Link/endpoints for internal-only access where possible.

### Storage
- Use Premium SSD managed disks for Nexus and Vault for performance.
- Consider RAID 10 for Nexus if you expect heavy artifact load and want redundancy.

### Monitoring & Backup
- Enable Azure Monitor/Log Analytics for all VMs and AKS.
- Set up regular VM and disk snapshots for Nexus and Vault.

### Environment Management (GitHub Actions)
- Use GitHub Environments to group deployments (dev, stage, prod), set environment-specific secrets, and require approvals.

### Code Scanning (SAST/DAST)
- Run SAST/DAST tools (e.g., SonarQube, Trivy, Checkov) on self-hosted runners as part of your pipeline.
- SAST scans code for vulnerabilities before deployment; DAST scans running applications.

---

## Self-hosted Runners
- [ ] Deploy AKS cluster for GitHub Actions runners
- [ ] Set up actions-runner-controller or custom runner orchestration
- [ ] Configure auto-scaling and security for runners

## Nexus OSS
- [ ] Provision dedicated VM (or AKS) for Nexus
- [ ] Attach and configure RAID SSD managed disks
- [ ] Harden access with NSG/firewall and private endpoint
- [ ] Set up regular backups and monitoring

## HashiCorp Vault
- [ ] Deploy Vault on dedicated VMs (start with 1, plan for 3+ for HA)
- [ ] Configure managed disks and enable auto-unseal with Azure Key Vault
- [ ] Secure with NSG, TLS, and private endpoint
- [ ] Set up backup and monitoring

## Networking & Security
- [ ] Create secure VNet and subnets for all components
- [ ] Apply NSGs to restrict access
- [ ] Enable Azure Monitor/Log Analytics for all infra

## Storage
- [ ] Use Premium SSD managed disks for Nexus and Vault
- [ ] Configure RAID 10 for Nexus if needed

## Monitoring & Backup
- [ ] Enable monitoring and alerting for all VMs and AKS
- [ ] Schedule regular VM and disk snapshots

---

*Update this checklist as you progress through the CI/CD stack deployment.*
