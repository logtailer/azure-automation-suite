#!/usr/bin/env bash
set -euo pipefail

# Rotate AKS cluster credentials (service principal or managed identity certificates)
# Usage: ./rotate-aks-credentials.sh <resource-group> <cluster-name>

RESOURCE_GROUP="${1:-}"
CLUSTER_NAME="${2:-}"

if [[ -z "$RESOURCE_GROUP" || -z "$CLUSTER_NAME" ]]; then
  echo "Usage: $0 <resource-group> <cluster-name>" >&2
  exit 1
fi

echo "Rotating credentials for AKS cluster: $CLUSTER_NAME in $RESOURCE_GROUP"
echo "WARNING: This will briefly disrupt cluster operations. Ensure no critical deployments are in flight."

read -rp "Confirm rotation [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

az aks rotate-certs \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CLUSTER_NAME" \
  --yes

echo "Credentials rotated successfully. Refreshing kubeconfig..."
az aks get-credentials \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CLUSTER_NAME" \
  --overwrite-existing

echo "Verifying cluster connectivity..."
kubectl get nodes

echo "AKS credential rotation complete."
