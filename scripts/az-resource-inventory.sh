#!/usr/bin/env bash
set -euo pipefail

# Generate a full Azure resource inventory CSV for a subscription or resource group
# Usage: ./az-resource-inventory.sh [--rg <resource-group>] [--subscription <id>] [--output <file>]

RG=""
SUBSCRIPTION=""
OUTPUT="az-inventory-$(date +%Y%m%d).csv"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --rg) RG="$2"; shift 2 ;;
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$SUBSCRIPTION" ]]; then
  az account set --subscription "$SUBSCRIPTION"
fi

QUERY_ARGS=()
if [[ -n "$RG" ]]; then
  QUERY_ARGS+=(--resource-group "$RG")
fi

echo "Fetching resource inventory..."

echo "name,resourceGroup,type,location,subscriptionId,tags" > "$OUTPUT"

az resource list "${QUERY_ARGS[@]}" \
  --query "[].{name:name, rg:resourceGroup, type:type, location:location, sub:subscriptionId, tags:tags}" \
  -o json \
  | jq -r '.[] | [.name, .rg, .type, .location, .sub, (.tags | to_entries | map("\(.key)=\(.value)") | join("|"))] | @csv' \
  >> "$OUTPUT"

COUNT=$(tail -n +2 "$OUTPUT" | wc -l | tr -d ' ')
echo "Inventory complete: $COUNT resources written to $OUTPUT"
