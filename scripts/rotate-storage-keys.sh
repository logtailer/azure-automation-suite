#!/usr/bin/env bash
set -euo pipefail

# Rotate a storage account access key and update dependent Key Vault secrets
# Usage: ./rotate-storage-keys.sh --account <name> --rg <rg> --key-number <1|2> [--vault <kv>] [--secret-name <name>]

ACCOUNT=""
RESOURCE_GROUP=""
KEY_NUMBER="1"
VAULT=""
SECRET_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --account)     ACCOUNT="$2";       shift 2 ;;
    --rg)          RESOURCE_GROUP="$2"; shift 2 ;;
    --key-number)  KEY_NUMBER="$2";    shift 2 ;;
    --vault)       VAULT="$2";         shift 2 ;;
    --secret-name) SECRET_NAME="$2";   shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$ACCOUNT"        ]] && { echo "ERROR: --account required" >&2; exit 1; }
[[ -z "$RESOURCE_GROUP" ]] && { echo "ERROR: --rg required"      >&2; exit 1; }
[[ "$KEY_NUMBER" != "1" && "$KEY_NUMBER" != "2" ]] && { echo "ERROR: --key-number must be 1 or 2" >&2; exit 1; }

echo "=== Storage Account Key Rotation ==="
echo "    Account : $ACCOUNT"
echo "    RG      : $RESOURCE_GROUP"
echo "    Key     : key${KEY_NUMBER}"
echo ""

echo "Regenerating key${KEY_NUMBER}..."
az storage account keys renew \
  --account-name "$ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --key "key${KEY_NUMBER}" \
  --output none

NEW_KEY=$(az storage account keys list \
  --account-name "$ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[?keyName=='key${KEY_NUMBER}'].value" \
  -o tsv)

echo "Key rotated successfully."

if [[ -n "$VAULT" ]]; then
  [[ -z "$SECRET_NAME" ]] && SECRET_NAME="${ACCOUNT}-key${KEY_NUMBER}"
  echo "Updating Key Vault secret: ${VAULT}/${SECRET_NAME}"
  az keyvault secret set \
    --vault-name "$VAULT" \
    --name "$SECRET_NAME" \
    --value "$NEW_KEY" \
    --output none
  echo "Key Vault secret updated."
fi

echo ""
echo "Done. Update any connection strings or SAS tokens that use key${KEY_NUMBER}."
