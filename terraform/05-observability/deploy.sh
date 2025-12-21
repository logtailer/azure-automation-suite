#!/bin/bash

# Try to initialize backend, handle backend reconfiguration/migration prompts
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
