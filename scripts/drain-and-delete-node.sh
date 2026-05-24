#!/usr/bin/env bash
set -euo pipefail

# Safely drain a Kubernetes node and optionally delete the backing Azure VM
# Usage: ./drain-and-delete-node.sh --node <name> [--context <ctx>] [--delete-vm] [--timeout <s>]

NODE_NAME=""
CONTEXT=""
DELETE_VM=false
DRAIN_TIMEOUT=300

while [[ $# -gt 0 ]]; do
  case "$1" in
    --node)       NODE_NAME="$2";    shift 2 ;;
    --context)    CONTEXT="$2";      shift 2 ;;
    --delete-vm)  DELETE_VM=true;    shift   ;;
    --timeout)    DRAIN_TIMEOUT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$NODE_NAME" ]] && { echo "ERROR: --node required" >&2; exit 1; }

KUBECTL="kubectl"
[[ -n "$CONTEXT" ]] && KUBECTL="kubectl --context $CONTEXT"

echo "=== Drain and Delete Node: $NODE_NAME ==="
echo ""

# Show node status before
echo "--- Node Status ---"
$KUBECTL get node "$NODE_NAME" -o wide
echo ""

# Cordon first to prevent new pod scheduling
echo "Cordoning node..."
$KUBECTL cordon "$NODE_NAME"

# Show pods that will be evicted
echo ""
echo "--- Pods to be evicted ---"
$KUBECTL get pods --all-namespaces \
  --field-selector spec.nodeName="$NODE_NAME" \
  --no-headers | grep -v "Completed" || echo "(none)"

echo ""
read -rp "Proceed with drain? (yes/no): " CONFIRM
[[ "$CONFIRM" != "yes" ]] && { echo "Aborted. Node remains cordoned."; exit 0; }

# Drain the node
echo ""
echo "Draining node (timeout: ${DRAIN_TIMEOUT}s)..."
$KUBECTL drain "$NODE_NAME" \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --timeout="${DRAIN_TIMEOUT}s"

echo "Node drained successfully."

if [[ "$DELETE_VM" == "true" ]]; then
  echo ""
  VM_RESOURCE_ID=$($KUBECTL get node "$NODE_NAME" \
    -o jsonpath='{.spec.providerID}' | sed 's|azure://||')
  if [[ -z "$VM_RESOURCE_ID" ]]; then
    echo "WARNING: Could not determine Azure VM resource ID — skipping VM deletion."
  else
    echo "Deleting Azure VM: $VM_RESOURCE_ID"
    az resource delete --ids "$VM_RESOURCE_ID" --yes
    echo "VM deleted."
  fi
fi

echo ""
echo "Done. Run 'kubectl delete node $NODE_NAME' to remove the node object from the cluster."
