#!/bin/bash
set -euo pipefail
# Enforces CanNotDelete locks on all production resource groups in a subscription

SUBSCRIPTION="${1:?Usage: lock-resources.sh <subscription-id> [environment]}"
ENVIRONMENT="${2:-production}"
LOCK_NAME="platform-no-delete"

az account set --subscription "$SUBSCRIPTION"

echo "Scanning resource groups tagged environment=$ENVIRONMENT..."
RESOURCE_GROUPS=$(az group list \
  --query "[?tags.Environment=='$ENVIRONMENT' || tags.environment=='$ENVIRONMENT'].name" \
  --output tsv)

if [[ -z "$RESOURCE_GROUPS" ]]; then
  echo "No resource groups found for environment=$ENVIRONMENT"
  exit 0
fi

APPLIED=0
SKIPPED=0

while IFS= read -r rg; do
  EXISTING=$(az lock list \
    --resource-group "$rg" \
    --query "[?level=='CanNotDelete'].name" \
    --output tsv 2>/dev/null)

  if [[ -n "$EXISTING" ]]; then
    echo "  SKIP  $rg — lock already present ($EXISTING)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  echo "  APPLY $rg — creating CanNotDelete lock..."
  az lock create \
    --name "$LOCK_NAME" \
    --resource-group "$rg" \
    --lock-type CanNotDelete \
    --notes "Managed by platform engineering. Removal requires ITSM approval." \
    --output none
  APPLIED=$((APPLIED + 1))
done <<< "$RESOURCE_GROUPS"

echo ""
echo "Done. Applied: $APPLIED | Skipped (already locked): $SKIPPED"
