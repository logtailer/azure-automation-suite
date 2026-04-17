#!/usr/bin/env bash
set -euo pipefail

# Chaos: cordon and reboot a random AKS node to test cluster resilience
# Usage: ./kill-random-node.sh [--node-pool <name>] [--dry-run]

NODE_POOL=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --node-pool) NODE_POOL="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

LABEL_SELECTOR=""
if [[ -n "$NODE_POOL" ]]; then
  LABEL_SELECTOR="--selector agentpool=$NODE_POOL"
fi

NODES=$(kubectl get nodes $LABEL_SELECTOR --no-headers -o custom-columns=NAME:.metadata.name)
NODE_COUNT=$(echo "$NODES" | wc -l | tr -d ' ')

if [[ "$NODE_COUNT" -lt 2 ]]; then
  echo "Need at least 2 nodes to safely chaos-test. Aborting." >&2
  exit 1
fi

TARGET=$(echo "$NODES" | shuf -n1)
echo "Selected target node: $TARGET"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] Would cordon and reboot: $TARGET"
  exit 0
fi

echo "Cordoning $TARGET..."
kubectl cordon "$TARGET"

echo "Triggering reboot via node annotation..."
kubectl annotate node "$TARGET" "chaos/rebooted-at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" --overwrite

NODE_IP=$(kubectl get node "$TARGET" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
echo "Rebooting node at $NODE_IP via az vmss reboot..."
VMSS_NAME=$(kubectl get node "$TARGET" -o jsonpath='{.metadata.labels.kubernetes\.azure\.com/agentpool}')

echo "Node $TARGET scheduled for reboot. Monitor: kubectl get nodes -w"
