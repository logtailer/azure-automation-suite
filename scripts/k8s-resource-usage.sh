#!/usr/bin/env bash
set -euo pipefail

# Show per-namespace CPU and memory requests/limits vs allocatable capacity
# Usage: ./k8s-resource-usage.sh [--context <kube-context>]

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

echo "=== Node Allocatable Capacity ==="
$KUBECTL get nodes -o custom-columns=\
"NAME:.metadata.name,\
CPU:.status.allocatable.cpu,\
MEMORY:.status.allocatable.memory,\
PODS:.status.allocatable.pods"

echo ""
echo "=== Resource Requests by Namespace ==="
$KUBECTL get pods -A --no-headers \
  -o custom-columns="NS:.metadata.namespace,POD:.metadata.name,CONTAINER:.spec.containers[*].name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory" \
  | sort | head -60

echo ""
echo "=== Top Pods by CPU (kubectl top) ==="
$KUBECTL top pods -A --sort-by=cpu 2>/dev/null | head -20 || echo "Metrics server not available"

echo ""
echo "=== Top Pods by Memory ==="
$KUBECTL top pods -A --sort-by=memory 2>/dev/null | head -20 || echo "Metrics server not available"
