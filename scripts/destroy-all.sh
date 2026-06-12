#!/usr/bin/env bash
# Destroy all 15 modules in reverse dependency order.
# Usage: ./scripts/destroy-all.sh [--auto-approve]
#
# Prerequisites: same ARM_* env vars as deploy-all.sh

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

# Verify ARM credentials
for var in ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_SUBSCRIPTION_ID ARM_TENANT_ID; do
    if [[ -z "${!var:-}" ]]; then
        echo "ERROR: $var is not set. Export it or add it to .env" >&2
        exit 1
    fi
done

# Reverse order — destroy dependents first
MODULES=(
    "15-policy"
    "14-database"
    "13-traffic-manager"
    "12-appgateway"
    "11-backup"
    "10-cost-management"
    "09-governance"
    "08-artifactory"
    "07-idp"
    "06-cicd"
    "05-observability"
    "04-aks"
    "03-security"
    "02-networking"
    "01-foundation"
)

FAILED=()

destroy_module() {
    local module="$1"
    local dir="$REPO_ROOT/terraform/$module"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Destroying: $module"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ ! -f "$dir/$TFVARS" ]]; then
        echo "SKIP: $dir/$TFVARS not found"
        return 0
    fi

    pushd "$dir" > /dev/null

    if [[ -f "backend.hcl" ]]; then
        terraform init -reconfigure -backend-config=backend.hcl
    else
        terraform init -reconfigure -backend=false
    fi

    if [[ "$AUTO_APPROVE" == "--auto-approve" ]]; then
        terraform destroy -var-file="$TFVARS" -auto-approve
    else
        terraform destroy -var-file="$TFVARS"
    fi

    popd > /dev/null
}

START=$(date +%s)

# Confirm unless --auto-approve
if [[ "$AUTO_APPROVE" != "--auto-approve" ]]; then
    echo "WARNING: This will destroy ALL resources across all 15 modules."
    read -r -p "Type 'destroy' to confirm: " CONFIRM
    if [[ "$CONFIRM" != "destroy" ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "Starting full stack teardown — $(date)"

for module in "${MODULES[@]}"; do
    if ! destroy_module "$module"; then
        echo "ERROR: $module failed — continuing with remaining modules" >&2
        FAILED+=("$module")
    fi
done

END=$(date +%s)
ELAPSED=$(( END - START ))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Teardown complete in $(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s"
if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo "  FAILED modules: ${FAILED[*]}"
    exit 1
else
    echo "  All resources destroyed — credits preserved"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
