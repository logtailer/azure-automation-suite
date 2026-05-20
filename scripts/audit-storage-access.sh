#!/usr/bin/env bash
set -euo pipefail

# Audit Azure storage account access: public blob access, network rules, shared key auth
# Usage: ./audit-storage-access.sh [--rg <resource-group>] [--output <table|json>]

RESOURCE_GROUP=""
OUTPUT_FMT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --rg)     RESOURCE_GROUP="$2"; shift 2 ;;
    --output) OUTPUT_FMT="$2";     shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

RG_ARG=""
[[ -n "$RESOURCE_GROUP" ]] && RG_ARG="--resource-group $RESOURCE_GROUP"

echo "=== Storage Account Security Audit ==="
echo ""

ACCOUNTS=$(az storage account list $RG_ARG \
  --query "[].{Name:name,RG:resourceGroup,PublicAccess:allowBlobPublicAccess,SharedKey:allowSharedKeyAccess,NetworkDefault:networkAcls.defaultAction,HTTPS:supportsHttpsTrafficOnly}" \
  -o json)

echo "--- Public Blob Access Enabled ---"
echo "$ACCOUNTS" | jq -r '.[] | select(.PublicAccess == true) | [.Name, .RG] | @tsv' \
  | column -t || echo "None found"

echo ""
echo "--- Shared Key Access Enabled ---"
echo "$ACCOUNTS" | jq -r '.[] | select(.SharedKey != false) | [.Name, .RG] | @tsv' \
  | column -t || echo "None found"

echo ""
echo "--- Network: Allow All (no restrictions) ---"
echo "$ACCOUNTS" | jq -r '.[] | select(.NetworkDefault == "Allow") | [.Name, .RG] | @tsv' \
  | column -t || echo "None found"

echo ""
echo "--- HTTPS Not Enforced ---"
echo "$ACCOUNTS" | jq -r '.[] | select(.HTTPS != true) | [.Name, .RG] | @tsv' \
  | column -t || echo "None found"

echo ""
echo "--- Full Summary ---"
case "$OUTPUT_FMT" in
  json)
    echo "$ACCOUNTS" | jq .
    ;;
  table|*)
    echo "$ACCOUNTS" | jq -r '
      (["NAME","RG","PUBLIC","SHARED_KEY","NET_DEFAULT","HTTPS_ONLY"] | @tsv),
      (.[] | [.Name, .RG, (.PublicAccess|tostring), (.SharedKey|tostring), .NetworkDefault, (.HTTPS|tostring)] | @tsv)
    ' | column -t
    ;;
esac
