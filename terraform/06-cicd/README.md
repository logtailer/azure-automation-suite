# CI/CD Infrastructure Module

Deploys self-hosted GitHub runners on Azure Kubernetes Service (AKS) with ArgoCD for GitOps continuous delivery.

## Components

- **AKS Cluster**: Kubernetes cluster with 2 node pools
  - System node pool (always-on): 1x Standard_B2s
  - Runner node pool (scale-to-zero): 0-5x Standard_D2s_v3
- **Actions Runner Controller (ARC)**: GitHub Actions self-hosted runners on Kubernetes
- **ArgoCD**: GitOps continuous delivery tool with LoadBalancer access
- **GitHub Actions Workflow Templates**: Reusable workflow patterns

## Architecture

```
AKS Cluster (aks-cicd-dev)
├── System Node Pool (1x B2s, always-on)
├── Runner Node Pool (0-5x D2s_v3, scale-to-zero)
├── actions-runner-system namespace
│   ├── ARC Controller
│   └── Runner Scale Set (repository-level)
└── argocd namespace
    └── ArgoCD Server (LoadBalancer)
```

## Prerequisites

1. **GitHub Personal Access Token** (fine-grained):
   - Repository permissions: `repo`, `workflow`, `admin:repo_hook`
   - Create at: https://github.com/settings/tokens

2. **GitHub Webhook Secret**:
   ```bash
   openssl rand -hex 32
   ```

3. **Azure Credentials**:
   - Service principal with Contributor access
   - Or use Azure CLI authentication

4. **Networking Module Deployed**:
   - Subnet `snet-aks-cicd` must exist (deployed in Commit 1)

## Deployment

### 1. Configure Secrets

```bash
# Copy template
cp .env.template .env

# Edit .env with actual values
vi .env
```

### 2. Deploy Infrastructure

```bash
# Deploy to dev environment
./deploy.sh dev.tfvars
```

### 3. Access AKS Cluster

```bash
# Get credentials
az aks get-credentials --resource-group azure-platform-dev-rg --name aks-cicd-dev

# Verify connection
kubectl get nodes
kubectl get pods -n actions-runner-system
kubectl get pods -n argocd
```

### 4. Access ArgoCD

```bash
# Get ArgoCD URL
terraform output argocd_url

# Get admin password
terraform output -raw argocd_admin_password

# Login via browser or CLI
argocd login <argocd-url> --username admin --password <password>
```

### 5. Verify Self-Hosted Runners

Check that runners are registered in your GitHub repository:
- Navigate to: `Settings` → `Actions` → `Runners`
- You should see the runner scale set listed

## Configuration

### Key Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `github_repository_owner` | GitHub username | - |
| `github_repository_name` | Repository name | - |
| `kubernetes_version` | AKS version | `1.28` |
| `system_node_size` | System node VM size | `Standard_B2s` |
| `runner_node_size` | Runner node VM size | `Standard_D2s_v3` |
| `runner_node_max_count` | Max runner nodes | `5` |
| `component_budget_amount` | Monthly budget USD | `100` |

### Environment-Specific Files

- **core.tfvars**: Shared configuration across environments
- **dev.tfvars**: Development environment overrides

## Cost Estimation

| Resource | Configuration | Monthly Cost |
|----------|--------------|--------------|
| AKS Control Plane | Free tier | $0 |
| System Node Pool | 1x B2s (730 hrs) | ~$25 |
| Runner Node Pool (Idle) | 0 nodes | $0 |
| Runner Node Pool (Active) | 2x D2s_v3 (180 hrs) | ~$50 |
| Load Balancer | Standard SKU | ~$20 |
| Data Transfer | 10 GB/month | ~$1 |
| Log Analytics | 5 GB/month | ~$2 |
| **Total (Idle)** | | **~$78/month** |
| **Total (Active)** | 2-3 runners | **~$103/month** |

**Key Cost Optimizations:**
- Scale-to-zero runner pool saves ~$400/month vs always-on
- Webhook-based scaling vs polling reduces idle time
- B2s system nodes vs D-series saves ~$30/month

## Usage

### Using Self-Hosted Runners

Update your GitHub Actions workflows to use `runs-on: self-hosted`:

```yaml
name: CI Pipeline
on: push

jobs:
  build:
    runs-on: self-hosted  # Use AKS runners
    steps:
      - uses: actions/checkout@v4
      - run: echo "Running on self-hosted runner!"
      - run: docker --version  # Docker-in-Docker available
```

### Runner Labels

Runners are automatically labeled:
- `self-hosted`
- `aks`
- `azure`

Target specific runners:

```yaml
runs-on: [self-hosted, aks, azure]
```

## Monitoring

### Check Runner Scaling

```bash
# View runner pods
kubectl get pods -n actions-runner-system

# Check autoscaling events
kubectl get events -n actions-runner-system --sort-by='.lastTimestamp'

# View runner logs
kubectl logs -n actions-runner-system -l app=runner
```

### Monitor Costs

```bash
# View current spend
az consumption usage list --resource-group azure-platform-dev-rg

# Check budget alerts
az consumption budget list --resource-group-name azure-platform-dev-rg
```

## Troubleshooting

### Runners Not Scaling

```bash
# Check ARC controller logs
kubectl logs -n actions-runner-system -l app=arc-controller

# Check webhook listener
kubectl get pods -n actions-runner-system -l app=arc-listener

# View runner scale set status
kubectl describe runnerscaleset -n actions-runner-system
```

### ArgoCD Not Accessible

```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# Get LoadBalancer IP
kubectl get svc argocd-server -n argocd

# Check ArgoCD logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

### AKS Node Issues

```bash
# View node status
kubectl get nodes -o wide

# Check node pool autoscaling
az aks nodepool show --resource-group azure-platform-dev-rg \
  --cluster-name aks-cicd-dev --name runners
```

## Security Considerations

1. **GitHub Token Security**:
   - Use fine-grained tokens with minimal permissions
   - Rotate tokens regularly (every 90 days)
   - Store in Azure Key Vault (future enhancement)

2. **Network Security**:
   - Runners deployed in dedicated subnet with NAT gateway
   - Service endpoints for ACR and Storage
   - Network policies enforce pod-to-pod restrictions

3. **RBAC**:
   - AKS uses Azure RBAC for cluster access
   - Kubernetes service accounts with minimal permissions
   - ArgoCD projects for application isolation

## Integration with Other Modules

### Artifactory (Nexus)
Push/pull artifacts in workflows:

```yaml
- name: Push to Nexus
  run: |
    mvn deploy -DaltDeploymentRepository=nexus::default::${{ secrets.NEXUS_URL }}/repository/maven-releases
```

### Observability
AKS metrics automatically sent to Log Analytics workspace (deployed in Commit 4).

## Next Steps

1. **Configure Workflow Templates**: Add common pipeline patterns to `.github/workflows/`
2. **Enable Observability**: Deploy monitoring alerts for AKS cluster
3. **Set Up ArgoCD Applications**: Deploy apps via GitOps
4. **Optimize Costs**: Adjust node pool sizing based on usage patterns

## References

- [Actions Runner Controller Documentation](https://github.com/actions/actions-runner-controller)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [AKS Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
