# AKS Runners for GitHub Actions

This directory provisions an Azure Kubernetes Service (AKS) cluster dedicated for running self-hosted GitHub Actions runners.

## How it works
- Fetches VNet/subnet and resource group info from the main networking stack using `terraform_remote_state`.
- Deploys an AKS cluster into the selected subnet (default: `private_subnet1`).
- Parameterized for dev, stage, and prod environments.
- Outputs cluster name, kubeconfig, and node resource group.

## Usage
1. Update the `terraform_remote_state` backend config in `main.tf` to match your networking state storage.
2. Set variables in the appropriate tfvars file (`dev.tfvars`, `stage.tfvars`, `prod.tfvars`).
3. Run:
   ```sh
   terraform init -backend-config=dev-backend.hcl
   terraform plan -var-file=dev.tfvars
   terraform apply -var-file=dev.tfvars
   ```
4. After deployment, use the kubeconfig output to connect and install actions-runner-controller or your preferred runner manager.

## Notes
- Make sure the subnet used for AKS is not delegated to other services.
- Adjust node pool size and VM type as needed for your workload.
- Secure the cluster and restrict access as per your org’s security policy.
