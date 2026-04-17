#!/usr/bin/env bash
set -euo pipefail

# Chaos: simulate network partition by applying a deny-all NetworkPolicy to a namespace
# Usage: ./network-partition.sh <namespace> [--duration-seconds <n>] [--dry-run]

NAMESPACE="${1:-}"
DURATION=60
DRY_RUN=false

if [[ -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <namespace> [--duration-seconds <n>] [--dry-run]" >&2
  exit 1
fi

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --duration-seconds) DURATION="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

POLICY_NAME="chaos-network-partition-$(date +%s)"

POLICY_YAML=$(cat <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: $POLICY_NAME
  namespace: $NAMESPACE
  labels:
    chaos: network-partition
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
EOF
)

echo "Network partition target: $NAMESPACE"
echo "Duration: ${DURATION}s"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] Would apply NetworkPolicy:"
  echo "$POLICY_YAML"
  exit 0
fi

echo "Applying deny-all NetworkPolicy..."
echo "$POLICY_YAML" | kubectl apply -f -

echo "Partition active. Sleeping ${DURATION}s..."
sleep "$DURATION"

echo "Removing NetworkPolicy — restoring connectivity..."
kubectl delete networkpolicy "$POLICY_NAME" -n "$NAMESPACE"

echo "Network partition chaos test complete."
