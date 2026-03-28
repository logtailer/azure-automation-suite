#!/usr/bin/env bash
set -euo pipefail

# Safely cordon and drain an AKS node before maintenance or decommission
# Usage: ./aks-node-drain.sh <node-name> [--delete-local-data] [--ignore-daemonsets]

NODE="${1:-}"
EXTRA_ARGS=()

if [[ -z "$NODE" ]]; then
  echo "Usage: $0 <node-name> [--delete-local-data] [--ignore-daemonsets]" >&2
  exit 1
fi

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --delete-local-data) EXTRA_ARGS+=(--delete-emptydir-data) ;;
    --ignore-daemonsets) EXTRA_ARGS+=(--ignore-daemonsets) ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
  shift
done

echo "Cordoning node: $NODE"
kubectl cordon "$NODE"

echo "Draining node: $NODE"
kubectl drain "$NODE" \
  --grace-period=60 \
  --timeout=300s \
  "${EXTRA_ARGS[@]}"

echo "Node $NODE is drained and ready for maintenance."
echo "To uncordon when done: kubectl uncordon $NODE"
