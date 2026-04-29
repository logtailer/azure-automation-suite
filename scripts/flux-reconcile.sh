#!/usr/bin/env bash
set -euo pipefail

# Force Flux to reconcile all sources and kustomizations immediately
# Usage: ./flux-reconcile.sh [--namespace <ns>] [--context <kube-context>]

FLUX_NS="flux-system"
CONTEXT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) FLUX_NS="$2"; shift 2 ;;
    --context) CONTEXT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

KUBECTL="kubectl"
FLUX="flux"
if [[ -n "$CONTEXT" ]]; then
  KUBECTL="kubectl --context $CONTEXT"
  FLUX="flux --context $CONTEXT"
fi

echo "Reconciling Flux sources..."
$FLUX reconcile source git --all --namespace "$FLUX_NS"

echo ""
echo "Reconciling Flux kustomizations..."
$FLUX reconcile kustomization --all --namespace "$FLUX_NS"

echo ""
echo "Flux reconciliation triggered. Checking status..."
$FLUX get all --namespace "$FLUX_NS"
