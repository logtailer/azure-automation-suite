#!/usr/bin/env bash
set -euo pipefail

# Promote or abort an Argo Rollouts canary deployment
# Usage: ./canary-promote.sh <rollout-name> <namespace> [--abort]

ROLLOUT="${1:-}"
NAMESPACE="${2:-}"
ABORT=false

if [[ -z "$ROLLOUT" || -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <rollout-name> <namespace> [--abort]" >&2
  exit 1
fi

shift 2
while [[ $# -gt 0 ]]; do
  case "$1" in
    --abort) ABORT=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

echo "=== Rollout Status: $ROLLOUT ($NAMESPACE) ==="
kubectl argo rollouts status "$ROLLOUT" -n "$NAMESPACE" --timeout 10s || true
echo ""

if [[ "$ABORT" == "true" ]]; then
  echo "Aborting rollout: $ROLLOUT"
  kubectl argo rollouts abort "$ROLLOUT" -n "$NAMESPACE"
  echo "Rollout aborted. Waiting for stable state..."
  kubectl argo rollouts status "$ROLLOUT" -n "$NAMESPACE" --timeout 120s
else
  echo "Promoting canary: $ROLLOUT"
  kubectl argo rollouts promote "$ROLLOUT" -n "$NAMESPACE"
  echo "Promotion triggered. Monitor with: kubectl argo rollouts get rollout $ROLLOUT -n $NAMESPACE --watch"
fi
