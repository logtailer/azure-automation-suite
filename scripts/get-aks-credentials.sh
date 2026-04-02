#!/usr/bin/env bash
set -euo pipefail

# Fetch AKS kubeconfig for all environments and merge into ~/.kube/config
# Usage: ./get-aks-credentials.sh [--env dev|staging|prod] [--subscription <id>]

ENV=""
SUBSCRIPTION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) ENV="$2"; shift 2 ;;
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

ENVS=("dev" "staging" "prod")
if [[ -n "$ENV" ]]; then
  ENVS=("$ENV")
fi

if [[ -n "$SUBSCRIPTION" ]]; then
  az account set --subscription "$SUBSCRIPTION"
fi

for e in "${ENVS[@]}"; do
  RG="rg-platform-$e"
  CLUSTER="aks-platform-$e"

  if az aks show --resource-group "$RG" --name "$CLUSTER" &>/dev/null; then
    echo "Fetching credentials for $CLUSTER..."
    az aks get-credentials \
      --resource-group "$RG" \
      --name "$CLUSTER" \
      --overwrite-existing \
      --context "aks-$e"
    echo "  Context set: aks-$e"
  else
    echo "Skipping $CLUSTER (not found in $RG)"
  fi
done

echo ""
echo "Available contexts:"
kubectl config get-contexts
