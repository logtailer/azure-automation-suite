# 01-foundation

## Purpose
This component sets up the foundational Azure resources such as resource groups and storage accounts.

## Usage
- Edit `core.tfvars` with your values.
- Run `deploy.sh` or use Terraform CLI.

## Variables
- `resource_group_name`: Name of the resource group.
- `location`: Azure region.

## Outputs
- `resource_group_name`: The name of the created resource group.
