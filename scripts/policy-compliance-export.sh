#!/usr/bin/env bash
set -euo pipefail

# Export Azure Policy compliance state to JSON for reporting
# Usage: ./policy-compliance-export.sh [--subscription <id>] [--output <file>]

SUBSCRIPTION=""
OUTPUT_FILE="policy-compliance-$(date +%Y%m%d).json"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    --output) OUTPUT_FILE="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$SUBSCRIPTION" ]]; then
  az account set --subscription "$SUBSCRIPTION"
fi

SUB_ID=$(az account show --query id -o tsv)
echo "Exporting compliance for subscription: $SUB_ID"

az policy state list \
  --subscription "$SUB_ID" \
  --query "[].{
    resourceId: resourceId,
    policyName: policyDefinitionName,
    complianceState: complianceState,
    timestamp: timestamp,
    resourceType: resourceType,
    resourceGroup: resourceGroup
  }" \
  -o json > "$OUTPUT_FILE"

TOTAL=$(jq length "$OUTPUT_FILE")
NON_COMPLIANT=$(jq '[.[] | select(.complianceState == "NonCompliant")] | length' "$OUTPUT_FILE")

echo "Total resources evaluated: $TOTAL"
echo "Non-compliant resources:   $NON_COMPLIANT"
echo "Report written to: $OUTPUT_FILE"

if [[ "$NON_COMPLIANT" -gt 0 ]]; then
  echo ""
  echo "Non-compliant resources:"
  jq -r '.[] | select(.complianceState == "NonCompliant") | "\(.resourceGroup)/\(.resourceType | split("/")[-1]): \(.policyName)"' "$OUTPUT_FILE" | sort -u
fi
