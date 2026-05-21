#!/usr/bin/env bash
set -euo pipefail

# Migrate Terraform state between storage account containers
# Usage: ./migrate-tfstate.sh --src-account <name> --src-container <c> --src-key <k>
#                             --dst-account <name> --dst-container <c> --dst-key <k>
#                             [--dry-run]

SRC_ACCOUNT="" SRC_CONTAINER="" SRC_KEY=""
DST_ACCOUNT="" DST_CONTAINER="" DST_KEY=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --src-account)   SRC_ACCOUNT="$2";   shift 2 ;;
    --src-container) SRC_CONTAINER="$2"; shift 2 ;;
    --src-key)       SRC_KEY="$2";       shift 2 ;;
    --dst-account)   DST_ACCOUNT="$2";   shift 2 ;;
    --dst-container) DST_CONTAINER="$2"; shift 2 ;;
    --dst-key)       DST_KEY="$2";       shift 2 ;;
    --dry-run)       DRY_RUN=true;       shift   ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

for v in SRC_ACCOUNT SRC_CONTAINER SRC_KEY DST_ACCOUNT DST_CONTAINER DST_KEY; do
  [[ -z "${!v}" ]] && { echo "ERROR: --${v//_/-} required" >&2; exit 1; }
done

echo "=== Terraform State Migration ==="
echo "    Source: ${SRC_ACCOUNT}/${SRC_CONTAINER}/${SRC_KEY}"
echo "    Dest  : ${DST_ACCOUNT}/${DST_CONTAINER}/${DST_KEY}"
echo "    Dry run: ${DRY_RUN}"
echo ""

SRC_CONN=$(az storage account show-connection-string \
  --name "$SRC_ACCOUNT" --query "connectionString" -o tsv)
DST_CONN=$(az storage account show-connection-string \
  --name "$DST_ACCOUNT" --query "connectionString" -o tsv)

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[DRY-RUN] Would copy:"
  echo "  az storage blob copy start --connection-string <dst> --destination-blob $DST_KEY ..."
  echo "Done (dry run — no changes made)"
  exit 0
fi

echo "Downloading state from source..."
TMP_STATE=$(mktemp /tmp/tfstate-XXXXXX.json)
trap 'rm -f "$TMP_STATE"' EXIT

az storage blob download \
  --connection-string "$SRC_CONN" \
  --container-name "$SRC_CONTAINER" \
  --name "$SRC_KEY" \
  --file "$TMP_STATE" \
  --auth-mode login

echo "Uploading state to destination..."
az storage blob upload \
  --connection-string "$DST_CONN" \
  --container-name "$DST_CONTAINER" \
  --name "$DST_KEY" \
  --file "$TMP_STATE" \
  --overwrite true

echo ""
echo "State migration complete."
echo "Update your backend.hcl to point to the new location before running terraform init."
