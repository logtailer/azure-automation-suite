#!/usr/bin/env bash
set -euo pipefail

# Quick AKS cluster health check: nodes, system pods, and PDB status
# Usage: ./check-cluster-health.sh [--context <kube-context>]

CONTEXT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --context) CONTEXT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

KUBECTL="kubectl"
if [[ -n "$CONTEXT" ]]; then
  KUBECTL="kubectl --context $CONTEXT"
fi

FAILED=0

echo "=== Node Status ==="
NOT_READY=$($KUBECTL get nodes --no-headers | grep -v " Ready " | wc -l | tr -d ' ')
if [[ "$NOT_READY" -gt 0 ]]; then
  echo "WARN: $NOT_READY node(s) not Ready"
  $KUBECTL get nodes --no-headers | grep -v " Ready "
  FAILED=1
else
  echo "OK: all nodes Ready"
fi

echo ""
echo "=== System Pod Status ==="
FAILED_PODS=$($KUBECTL get pods -n kube-system --no-headers | grep -Ev "(Running|Completed)" | wc -l | tr -d ' ')
if [[ "$FAILED_PODS" -gt 0 ]]; then
  echo "WARN: $FAILED_PODS system pod(s) not healthy"
  $KUBECTL get pods -n kube-system --no-headers | grep -Ev "(Running|Completed)"
  FAILED=1
else
  echo "OK: all kube-system pods healthy"
fi

echo ""
echo "=== PodDisruptionBudgets ==="
$KUBECTL get pdb -A --no-headers 2>/dev/null | awk '{print $1, $2, "CURRENT:", $4, "DESIRED:", $3}' || echo "No PDBs found"

echo ""
if [[ "$FAILED" -eq 0 ]]; then
  echo "Cluster health check PASSED"
else
  echo "Cluster health check FAILED — review warnings above" >&2
  exit 1
fi
