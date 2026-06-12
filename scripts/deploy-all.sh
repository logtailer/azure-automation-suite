#!/usr/bin/env bash
# Deploy all 15 modules in dependency order using dev-minimal.tfvars.
# Usage: ./scripts/deploy-all.sh [--auto-approve]
#
# Prerequisites:
#   export ARM_CLIENT_ID=...
#   export ARM_CLIENT_SECRET=...
#   export ARM_SUBSCRIPTION_ID=...
#   export ARM_TENANT_ID=...
#   Or place those in a .env file at the repo root.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
TFVARS="dev-minimal.tfvars"
AUTO_APPROVE="${1:-}"

# Load .env if present
if [[ -f "$REPO_ROOT/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source "$REPO_ROOT/.env"
    set +a
    echo "Loaded credentials from .env"
fi

# Verify ARM credentials are set
for var in ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_SUBSCRIPTION_ID ARM_TENANT_ID; do
    if [[ -z "${!var:-}" ]]; then
        echo "ERROR: $var is not set. Export it or add it to .env" >&2
        exit 1
    fi
done

MODULES=(
    "01-foundation"
    "02-networking"
    "03-security"
    "04-aks"
    "05-observability"
    "06-cicd"
    "07-idp"
    "08-artifactory"
    "09-governance"
    "10-cost-management"
    "11-backup"
    "12-appgateway"
    "13-traffic-manager"
    "14-database"
    "15-policy"
)

FAILED=()

deploy_module() {
    local module="$1"
    local dir="$REPO_ROOT/terraform/$module"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Deploying: $module"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ ! -f "$dir/$TFVARS" ]]; then
        echo "SKIP: $dir/$TFVARS not found"
        return 0
    fi

    pushd "$dir" > /dev/null

    # Init
    if [[ -f "backend.hcl" ]]; then
        terraform init -reconfigure -backend-config=backend.hcl
    else
        terraform init -reconfigure -backend=false
    fi

    # Plan + apply
    if [[ "$AUTO_APPROVE" == "--auto-approve" ]]; then
        terraform apply -var-file="$TFVARS" -auto-approve
    else
        terraform apply -var-file="$TFVARS"
    fi

    popd > /dev/null
}

START=$(date +%s)
echo "Starting full stack deployment — $(date)"
echo "Modules: ${#MODULES[@]}"

for module in "${MODULES[@]}"; do
    if ! deploy_module "$module"; then
        echo "ERROR: $module failed" >&2
        FAILED+=("$module")
    fi
done

END=$(date +%s)
ELAPSED=$(( END - START ))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Deployment complete in $(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s"
if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo "  FAILED modules: ${FAILED[*]}"
    exit 1
else
    echo "  All modules deployed successfully"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
