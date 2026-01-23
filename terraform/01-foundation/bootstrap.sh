#!/bin/bash

# Bootstrap script for foundation module
# This script handles the initial creation of storage account for terraform state

set -e

ENVIRONMENT="${1:-dev}"
echo "Bootstrapping foundation for environment: $ENVIRONMENT"

# First run without backend to create the storage account
echo "Step 1: Creating storage account without backend..."
terraform init
terraform apply -auto-approve -var-file="${ENVIRONMENT}.tfvars"

# Get the storage account name from outputs
STORAGE_ACCOUNT=$(terraform output -raw tfstate_storage_account_name)
RESOURCE_GROUP=$(terraform output -raw tfstate_resource_group_name)

echo "Storage account created: $STORAGE_ACCOUNT"

# Now migrate to remote backend
echo "Step 2: Migrating to remote backend..."
terraform init \
  -backend-config="storage_account_name=$STORAGE_ACCOUNT" \
  -backend-config="container_name=foundation" \
  -backend-config="key=foundation.tfstate" \
  -backend-config="resource_group_name=$RESOURCE_GROUP" \
  -backend-config="use_azuread_auth=true" \
  -migrate-state

echo "Foundation bootstrap completed successfully!"
echo "Storage account: $STORAGE_ACCOUNT"
echo "Resource group: $RESOURCE_GROUP"
