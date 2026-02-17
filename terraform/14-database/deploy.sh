#!/bin/bash
set -euo pipefail

ENV=${1:-dev}
ACTION=${2:-plan}

echo "Running terraform $ACTION for database module in $ENV environment..."

terraform init -backend-config=backend.hcl -reconfigure
terraform "$ACTION" -var-file="${ENV}.tfvars"
