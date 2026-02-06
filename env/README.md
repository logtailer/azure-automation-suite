# Environment Configuration

Each module carries its own `dev.tfvars`, `staging.tfvars`, and `prod.tfvars`.

| Environment | Purpose | Deployment cadence |
|-------------|---------|-------------------|
| dev | Local iteration, feature work | On every PR merge |
| staging | Pre-production validation | On release branch push |
| prod | Live workloads | Manual approval gate |

## Variable file locations

```
terraform/<module>/dev.tfvars
terraform/<module>/staging.tfvars
terraform/<module>/prod.tfvars
```

## Deploying to a specific environment

```bash
cd terraform/<module>
terraform init -backend-config=backend.hcl
terraform plan -var-file=<env>.tfvars
terraform apply -var-file=<env>.tfvars
```
