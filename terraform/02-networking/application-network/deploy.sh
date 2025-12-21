#!/bin/zsh

# Automatically export variables from .env if it exists
if [ -f "../../.env" ]; then
  export $(grep -v '^#' ../../.env | xargs)
  echo "Loaded environment variables from .env"
fi

# Usage: ./deploy.sh <component>.tfvars

if [ $# -ne 1 ]; then
  echo "Usage: $0 <component>.tfvars"
  exit 1
fi

TFVARS_FILE="$1"
COMPONENT_NAME="${TFVARS_FILE%.tfvars}"
STATE_KEY="${COMPONENT_NAME}.tfstate"

if [ ! -f "$TFVARS_FILE" ]; then
  echo "Error: tfvars file '$TFVARS_FILE' not found."
  exit 2
fi

echo "Deploying component: $COMPONENT_NAME"
echo "Using state key: $STATE_KEY"
echo "Using tfvars file: $TFVARS_FILE"

terraform init -reconfigure -backend-config=dev-backend.hcl -backend-config="key=$STATE_KEY"
terraform plan -var-file="$TFVARS_FILE" -var-file="core.tfvars"
terraform apply -var-file="$TFVARS_FILE" -var-file="core.tfvars"