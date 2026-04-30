#!/usr/bin/env bash
set -euo pipefail

# Audit Azure resources missing required tags and output a CSV report
# Usage: ./tag-audit.sh [--subscription <id>] [--output <file>]

SUBSCRIPTION=""
OUTPUT_FILE="tag-audit-$(date +%Y%m%d).csv"
REQUIRED_TAGS=("environment" "team" "cost-center" "managed-by")

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

echo "resourceId,resourceGroup,resourceType,missingTags" > "$OUTPUT_FILE"

echo "Scanning resources for missing required tags..."

RESOURCES=$(az resource list --query "[].{id:id,rg:resourceGroup,type:type,tags:tags}" -o json)

echo "$RESOURCES" | jq -c '.[]' | while read -r resource; do
  ID=$(echo "$resource" | jq -r '.id')
  RG=$(echo "$resource" | jq -r '.rg')
  TYPE=$(echo "$resource" | jq -r '.type')
  TAGS=$(echo "$resource" | jq -r '.tags // {} | keys[]' 2>/dev/null || echo "")

  MISSING=()
  for TAG in "${REQUIRED_TAGS[@]}"; do
    if ! echo "$TAGS" | grep -qi "^${TAG}$"; then
      MISSING+=("$TAG")
    fi
  done

  if [[ ${#MISSING[@]} -gt 0 ]]; then
    MISSING_STR=$(IFS=';'; echo "${MISSING[*]}")
    echo "\"$ID\",\"$RG\",\"$TYPE\",\"$MISSING_STR\"" >> "$OUTPUT_FILE"
  fi
done

TOTAL=$(tail -n +2 "$OUTPUT_FILE" | wc -l | tr -d ' ')
echo "Found $TOTAL resource(s) with missing tags. Report: $OUTPUT_FILE"
