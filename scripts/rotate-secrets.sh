#!/bin/bash
set -euo pipefail

VAULT_NAME=${1:?Usage: rotate-secrets.sh <vault-name> <secret-name>}
SECRET_NAME=${2:?Usage: rotate-secrets.sh <vault-name> <secret-name>}

echo "Rotating secret '$SECRET_NAME' in vault '$VAULT_NAME'..."

NEW_VALUE=$(openssl rand -base64 32)
az keyvault secret set \
  --vault-name "$VAULT_NAME" \
  --name "$SECRET_NAME" \
  --value "$NEW_VALUE" \
  --output none

echo "Secret rotated successfully. Update any dependent services."
