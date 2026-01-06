#!/bin/bash
# Backstage Deployment Script
# This script deploys the Backstage infrastructure and application

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT="${1:-dev}"
TFVARS_FILE="${ENVIRONMENT}.tfvars"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
log_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}"
}

check_prerequisites() {
  log_info "Checking prerequisites..."

  local missing_tools=()

  command -v az >/dev/null 2>&1 || missing_tools+=("azure-cli")
  command -v terraform >/dev/null 2>&1 || missing_tools+=("terraform")
  command -v docker >/dev/null 2>&1 || missing_tools+=("docker")
  command -v jq >/dev/null 2>&1 || missing_tools+=("jq")

  if [ ${#missing_tools[@]} -ne 0 ]; then
    log_error "Missing required tools: ${missing_tools[*]}"
    log_info "Please install the missing tools and try again."
    exit 1
  fi

  log_success "All prerequisites installed"
}

load_credentials() {
  log_info "Loading credentials..."

  if [ -f "${SCRIPT_DIR}/.env.${ENVIRONMENT}" ]; then
    log_info "Loading credentials from .env.${ENVIRONMENT}"
    # shellcheck disable=SC1090
    source "${SCRIPT_DIR}/.env.${ENVIRONMENT}"
  else
    log_warning "No .env.${ENVIRONMENT} file found"

    # Check if credentials are already in environment
    if [ -z "${TF_VAR_db_admin_password:-}" ]; then
      log_error "Missing required environment variable: TF_VAR_db_admin_password"
      cat <<EOF

Please set the following environment variables:
  export TF_VAR_db_admin_password="<secure-password>"
  export TF_VAR_github_token="ghp_xxxxxxxxxxxx"
  export TF_VAR_github_client_id="<oauth-client-id>"
  export TF_VAR_github_client_secret="<oauth-client-secret>"

Or create a .env.${ENVIRONMENT} file with these values.

To generate a secure password:
  openssl rand -base64 32

EOF
      exit 1
    fi
  fi

  # Validate required variables
  local required_vars=(
    "TF_VAR_db_admin_password"
    "TF_VAR_github_token"
    "TF_VAR_github_client_id"
    "TF_VAR_github_client_secret"
  )

  for var in "${required_vars[@]}"; do
    if [ -z "${!var:-}" ]; then
      log_error "Missing required variable: $var"
      exit 1
    fi
  done

  log_success "Credentials loaded successfully"
}

check_azure_login() {
  log_info "Checking Azure login status..."

  if ! az account show >/dev/null 2>&1; then
    log_warning "Not logged in to Azure"
    log_info "Running: az login"
    az login
  fi

  SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
  log_success "Logged in to Azure subscription: $SUBSCRIPTION_NAME"
}

deploy_infrastructure() {
  log_info "Deploying infrastructure with Terraform..."

  cd "${SCRIPT_DIR}"

  # Initialize Terraform
  log_info "Running: terraform init"
  terraform init -backend-config=backend.hcl

  # Validate configuration
  log_info "Running: terraform validate"
  terraform validate

  # Plan changes
  log_info "Running: terraform plan"
  terraform plan -var-file="${TFVARS_FILE}" -out=tfplan

  # Ask for confirmation
  echo ""
  read -p "Do you want to apply these changes? (yes/no): " -r
  if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    log_warning "Deployment cancelled by user"
    exit 0
  fi

  # Apply changes
  log_info "Running: terraform apply"
  terraform apply tfplan

  log_success "Infrastructure deployed successfully"
}

capture_outputs() {
  log_info "Capturing Terraform outputs..."

  cd "${SCRIPT_DIR}"

  # Export outputs to JSON file
  terraform output -json > outputs.json

  # Extract key outputs
  ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
  ACR_NAME=$(terraform output -raw container_registry_name)
  POSTGRES_HOST=$(terraform output -raw postgresql_server_fqdn)
  CONTAINER_FQDN=$(terraform output -raw container_fqdn)
  APPLICATION_ID=$(terraform output -raw application_id)
  TENANT_ID=$(terraform output -raw tenant_id)

  export ACR_LOGIN_SERVER ACR_NAME POSTGRES_HOST CONTAINER_FQDN APPLICATION_ID TENANT_ID

  log_success "Outputs captured:"
  echo "   ACR: $ACR_LOGIN_SERVER"
  echo "   PostgreSQL: $POSTGRES_HOST"
  echo "   Container FQDN: $CONTAINER_FQDN"
  echo "   Azure AD App ID: $APPLICATION_ID"
  echo "   Azure AD Tenant ID: $TENANT_ID"
}

build_backstage_image() {
  log_info "Building Backstage Docker image..."

  # Check if Backstage directory exists
  BACKSTAGE_DIR="${SCRIPT_DIR}/../../backstage"
  if [ ! -d "$BACKSTAGE_DIR" ]; then
    log_warning "Backstage directory not found at: $BACKSTAGE_DIR"
    log_warning "Skipping image build. Please build and push your Backstage image manually."
    log_info "Example commands:"
    echo "   cd /path/to/backstage"
    echo "   docker build -t ${ACR_LOGIN_SERVER}/backstage:latest ."
    echo "   az acr login --name ${ACR_NAME}"
    echo "   docker push ${ACR_LOGIN_SERVER}/backstage:latest"
    return 0
  fi

  cd "$BACKSTAGE_DIR"

  # Login to ACR
  log_info "Logging in to ACR..."
  az acr login --name "$ACR_NAME"

  # Build image
  log_info "Building Docker image: ${ACR_LOGIN_SERVER}/backstage:latest"
  docker build -t "${ACR_LOGIN_SERVER}/backstage:latest" .

  log_success "Image built successfully"
}

push_backstage_image() {
  log_info "Pushing Backstage image to ACR..."

  docker push "${ACR_LOGIN_SERVER}/backstage:latest"

  log_success "Image pushed successfully"
}

restart_container() {
  log_info "Restarting container instance to pick up new image..."

  cd "${SCRIPT_DIR}"

  RESOURCE_GROUP=$(terraform output -raw resource_group_name || echo "rg-platform-${ENVIRONMENT}-centralindia")
  CONTAINER_GROUP=$(terraform output -raw container_group_name)

  az container restart \
    --name "$CONTAINER_GROUP" \
    --resource-group "$RESOURCE_GROUP"

  log_success "Container restart initiated"
}

verify_deployment() {
  log_info "Verifying deployment..."

  BACKSTAGE_URL="http://${CONTAINER_FQDN}:7007"

  log_info "Waiting for container to become healthy (this may take up to 3 minutes)..."

  local max_attempts=36
  local attempt=0

  while [ $attempt -lt $max_attempts ]; do
    if curl -sf "${BACKSTAGE_URL}/healthcheck" >/dev/null 2>&1; then
      log_success "Backstage is healthy and running!"
      echo ""
      echo "🌐 Access Backstage at: $BACKSTAGE_URL"
      echo ""
      return 0
    fi

    attempt=$((attempt + 1))
    echo -n "."
    sleep 5
  done

  echo ""
  log_warning "Health check timed out. Backstage may still be starting."
  log_info "Check container logs with:"
  echo "   az container logs --name $CONTAINER_GROUP --resource-group $RESOURCE_GROUP --follow"
  echo ""
  log_info "Try accessing Backstage at: $BACKSTAGE_URL"
}

display_summary() {
  echo ""
  echo "========================================"
  echo "   DEPLOYMENT SUMMARY"
  echo "========================================"
  echo ""
  echo "Environment: $ENVIRONMENT"
  echo "Backstage URL: http://${CONTAINER_FQDN}:7007"
  echo "ACR: $ACR_LOGIN_SERVER"
  echo "PostgreSQL: $POSTGRES_HOST"
  echo ""
  echo "Azure AD Application:"
  echo "  App ID: $APPLICATION_ID"
  echo "  Tenant ID: $TENANT_ID"
  echo ""
  echo "Useful Commands:"
  echo "  View logs: az container logs --name $(terraform output -raw container_group_name) --resource-group $(terraform output -raw resource_group_name) --follow"
  echo "  Restart: az container restart --name $(terraform output -raw container_group_name) --resource-group $(terraform output -raw resource_group_name)"
  echo "  SSH to container: az container exec --name $(terraform output -raw container_group_name) --resource-group $(terraform output -raw resource_group_name) --exec-command /bin/bash"
  echo ""
  echo "========================================"
  echo "🎉 Deployment complete!"
  echo "========================================"
  echo ""
}

# Main execution
main() {
  echo ""
  echo "========================================"
  echo "   Backstage Deployment Script"
  echo "========================================"
  echo ""
  echo "Environment: $ENVIRONMENT"
  echo "Terraform vars: $TFVARS_FILE"
  echo ""

  check_prerequisites
  load_credentials
  check_azure_login
  deploy_infrastructure
  capture_outputs
  build_backstage_image
  push_backstage_image
  restart_container
  verify_deployment
  display_summary
}

# Run main function
main "$@"
