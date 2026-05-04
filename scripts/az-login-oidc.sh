#!/usr/bin/env bash
set -euo pipefail

# Authenticate to Azure using OIDC federated credentials (for CI/CD environments)
# Usage: ./az-login-oidc.sh [--subscription <id>]
# Requires: ARM_CLIENT_ID, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID, AZURE_FEDERATED_TOKEN_FILE

SUBSCRIPTION="${ARM_SUBSCRIPTION_ID:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

: "${ARM_CLIENT_ID:?ARM_CLIENT_ID must be set}"
: "${ARM_TENANT_ID:?ARM_TENANT_ID must be set}"
: "${AZURE_FEDERATED_TOKEN_FILE:?AZURE_FEDERATED_TOKEN_FILE must be set}"

if [[ ! -f "$AZURE_FEDERATED_TOKEN_FILE" ]]; then
  echo "Federated token file not found: $AZURE_FEDERATED_TOKEN_FILE" >&2
  exit 1
fi

echo "Logging in via OIDC federated credential..."
az login \
  --service-principal \
  --username "$ARM_CLIENT_ID" \
  --tenant "$ARM_TENANT_ID" \
  --federated-token "$(cat "$AZURE_FEDERATED_TOKEN_FILE")" \
  --output none

if [[ -n "$SUBSCRIPTION" ]]; then
  az account set --subscription "$SUBSCRIPTION"
fi

echo "Authenticated as: $(az account show --query 'user.name' -o tsv)"
echo "Subscription: $(az account show --query 'name' -o tsv)"
