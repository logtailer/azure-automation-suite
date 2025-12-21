#!/bin/bash
terraform init -backend-config=backend.hcl
terraform plan -var-file=core.tfvars
terraform apply -var-file=core.tfvars
