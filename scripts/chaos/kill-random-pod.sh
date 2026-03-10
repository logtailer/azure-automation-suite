#!/bin/bash
set -euo pipefail
NAMESPACE=${1:-default}
POD=$(kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | shuf -n1)
echo "Terminating pod: $POD in namespace: $NAMESPACE"
kubectl delete pod "$POD" -n "$NAMESPACE"
echo "Pod terminated. Watch recovery with: kubectl get pods -n $NAMESPACE -w"
