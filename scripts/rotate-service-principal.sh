#!/usr/bin/env bash
set -euo pipefail

# Rotate a service principal client secret and update it in Key Vault
# Usage: ./rotate-service-principal.sh --sp-id <app-id> --vault <kv-name> --secret-name <name> [--years <n>]

SP_ID=""
VAULT=""
SECRET_NAME=""
YEARS=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sp-id)       SP_ID="$2";       shift 2 ;;
    --vault)       VAULT="$2";       shift 2 ;;
    --secret-name) SECRET_NAME="$2"; shift 2 ;;
    --years)       YEARS="$2";       shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$SP_ID"       ]] && { echo "ERROR: --sp-id required"       >&2; exit 1; }
[[ -z "$VAULT"       ]] && { echo "ERROR: --vault required"       >&2; exit 1; }
[[ -z "$SECRET_NAME" ]] && { echo "ERROR: --secret-name required" >&2; exit 1; }

EXPIRY=$(date -u -d "+${YEARS} years" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
        || date -u -v+${YEARS}y +%Y-%m-%dT%H:%M:%SZ)

echo "=== Service Principal Secret Rotation ==="
echo "    App ID   : $SP_ID"
echo "    Key Vault: $VAULT"
echo "    KV secret: $SECRET_NAME"
echo "    Expires  : $EXPIRY"
echo ""

# Delete existing credentials older than 30 days
echo "Removing expired credentials..."
EXISTING=$(az ad app credential list --id "$SP_ID" \
  --query "[?endDateTime<'$(date -u +%Y-%m-%dT%H:%M:%SZ)'].keyId" -o tsv)
for KID in $EXISTING; do
  az ad app credential delete --id "$SP_ID" --key-id "$KID"
  echo "  Deleted credential: $KID"
done

# Create new client secret
echo "Creating new client secret..."
NEW_SECRET=$(az ad app credential reset \
  --id "$SP_ID" \
  --end-date "$EXPIRY" \
  --query "password" -o tsv)

# Store in Key Vault
echo "Storing new secret in Key Vault..."
az keyvault secret set \
  --vault-name "$VAULT" \
  --name "$SECRET_NAME" \
  --value "$NEW_SECRET" \
  --expires "$EXPIRY" \
  --query "id" -o tsv

echo ""
echo "Rotation complete. Old consumers must be updated to use the new credential."
