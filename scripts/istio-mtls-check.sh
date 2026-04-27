#!/usr/bin/env bash
set -euo pipefail

# Verify Istio mTLS status across namespaces
# Usage: ./istio-mtls-check.sh [--namespace <ns>]

NAMESPACE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) NAMESPACE="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

NAMESPACES=("platform" "monitoring" "istio-system")
if [[ -n "$NAMESPACE" ]]; then
  NAMESPACES=("$NAMESPACE")
fi

FAILED=0

for NS in "${NAMESPACES[@]}"; do
  echo "=== Namespace: $NS ==="

  # Check PeerAuthentication
  PA=$(kubectl get peerauthentication -n "$NS" --no-headers 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$PA" -gt 0 ]]; then
    kubectl get peerauthentication -n "$NS" -o custom-columns=NAME:.metadata.name,MODE:.spec.mtls.mode
  else
    echo "WARN: No PeerAuthentication in $NS — mTLS may not be enforced"
    FAILED=1
  fi

  echo ""

  # Check for STRICT mode
  STRICT=$(kubectl get peerauthentication -n "$NS" -o jsonpath='{.items[*].spec.mtls.mode}' 2>/dev/null || true)
  if [[ "$STRICT" == *"STRICT"* ]]; then
    echo "OK: STRICT mTLS enforced in $NS"
  else
    echo "WARN: STRICT mTLS not found in $NS (mode: ${STRICT:-unset})"
    FAILED=1
  fi
  echo ""
done

if [[ "$FAILED" -eq 0 ]]; then
  echo "mTLS check PASSED for all namespaces"
else
  echo "mTLS check FAILED — review warnings above" >&2
  exit 1
fi
