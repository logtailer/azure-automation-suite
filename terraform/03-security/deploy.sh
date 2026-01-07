#!/bin/bash

# Automatically export variables from .env if it exists
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
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

# Try to initialize backend
echo "Initializing Terraform backend..."
terraform init -backend-config=backend.hcl -backend-config="key=$STATE_KEY"
INIT_EXIT_CODE=$?
if [ $INIT_EXIT_CODE -ne 0 ]; then
  echo "Backend init failed, attempting reconfigure..."
  terraform init -reconfigure -backend-config=backend.hcl -backend-config="key=$STATE_KEY"
  INIT_EXIT_CODE=$?
  if [ $INIT_EXIT_CODE -ne 0 ]; then
    echo "Backend reconfigure failed, attempting migrate-state..."
    terraform init -migrate-state -backend-config=backend.hcl -backend-config="key=$STATE_KEY"
    INIT_EXIT_CODE=$?
    if [ $INIT_EXIT_CODE -ne 0 ]; then
      echo "ERROR: Terraform backend initialization failed after all attempts."
      exit 3
    fi
  fi
fi

echo "Terraform backend initialized successfully."
terraform plan -var-file="$TFVARS_FILE" -var-file="core.tfvars"
terraform apply -var-file="$TFVARS_FILE" -var-file="core.tfvars"
