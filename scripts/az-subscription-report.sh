#!/usr/bin/env bash
set -euo pipefail

# Generate a snapshot report of an Azure subscription: resource counts, costs, and quota usage
# Usage: ./az-subscription-report.sh [--subscription <id>] [--output <table|json>]

SUBSCRIPTION=""
OUTPUT_FMT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    --output)       OUTPUT_FMT="$2";   shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$SUBSCRIPTION" ]]; then
  az account set --subscription "$SUBSCRIPTION"
fi

SUB_NAME=$(az account show --query "name" -o tsv)
SUB_ID=$(az account show --query "id" -o tsv)

echo "=== Azure Subscription Report ==="
echo "    Name : $SUB_NAME"
echo "    ID   : $SUB_ID"
echo "    Date : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

echo "--- Resource Counts by Type ---"
az resource list --query "[].type" -o tsv \
  | sort | uniq -c | sort -rn \
  | awk '{printf "  %-6s %s\n", $1, $2}' \
  | head -20

echo ""
echo "--- Resource Groups ---"
az group list \
  --query "[].{Name:name,Location:location,State:properties.provisioningState}" \
  -o "${OUTPUT_FMT}" 2>/dev/null | head -30

echo ""
echo "--- vCPU Quota Usage (current region) ---"
LOCATION=$(az account list-locations --query "[?isDefault].name" -o tsv 2>/dev/null \
          || echo "eastus")
az vm list-usage --location "${LOCATION}" \
  --query "[?currentValue > \`0\`].{Name:localName,Used:currentValue,Limit:limit}" \
  -o "${OUTPUT_FMT}" 2>/dev/null | head -15

echo ""
echo "--- Top 5 Resource Groups by Resource Count ---"
az resource list --query "[].resourceGroup" -o tsv \
  | sort | uniq -c | sort -rn \
  | head -5 \
  | awk '{printf "  %-6s %s\n", $1, $2}'
