#!/bin/bash
set -euo pipefail
# Enables Network Watcher NSG flow logs (v2 + Traffic Analytics) for all NSGs in the subscription

SUBSCRIPTION="${1:?Usage: enable-flow-logs.sh <subscription-id> <storage-account-id> <log-analytics-workspace-id>}"
STORAGE_ID="${2:?}"
WORKSPACE_ID="${3:?}"
RETENTION_DAYS="${4:-90}"
FLOW_LOG_VERSION=2

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required but not installed" >&2
  exit 1
fi

az account set --subscription "$SUBSCRIPTION"

echo "Discovering Network Watchers..."
WATCHERS=$(az network watcher list \
  --query "[].{name:name, rg:resourceGroup, loc:location}" \
  --output json)

APPLIED=0
SKIPPED=0

while IFS= read -r watcher; do
  W_NAME=$(echo "$watcher" | jq -r '.name')
  W_RG=$(echo "$watcher" | jq -r '.rg')
  W_LOC=$(echo "$watcher" | jq -r '.loc')

  echo "Processing watcher: $W_NAME ($W_LOC)"

  NSGs=$(az network nsg list \
    --query "[?location=='$W_LOC'].{id:id, name:name}" \
    --output json)

  while IFS= read -r nsg; do
    NSG_ID=$(echo "$nsg" | jq -r '.id')
    NSG_NAME=$(echo "$nsg" | jq -r '.name')
    FL_NAME="fl-${NSG_NAME}"

    ENABLED=$(az network watcher flow-log show \
      --name "$FL_NAME" \
      --nsg "$NSG_ID" \
      --watcher-name "$W_NAME" \
      --watcher-rg "$W_RG" \
      --query "enabled" --output tsv 2>/dev/null || echo "notfound")

    if [[ "$ENABLED" == "true" ]]; then
      echo "  SKIP  $NSG_NAME — flow log already enabled"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    echo "  APPLY $NSG_NAME — enabling flow log v$FLOW_LOG_VERSION with Traffic Analytics..."
    az network watcher flow-log create \
      --name "$FL_NAME" \
      --nsg "$NSG_ID" \
      --storage-account "$STORAGE_ID" \
      --workspace "$WORKSPACE_ID" \
      --retention "$RETENTION_DAYS" \
      --log-version "$FLOW_LOG_VERSION" \
      --traffic-analytics \
      --interval 10 \
      --watcher-name "$W_NAME" \
      --watcher-rg "$W_RG" \
      --output none
    APPLIED=$((APPLIED + 1))
  done < <(echo "$NSGs" | jq -c '.[]')

done < <(echo "$WATCHERS" | jq -c '.[]')

echo ""
echo "Flow log enablement complete. Applied: $APPLIED | Skipped: $SKIPPED"
