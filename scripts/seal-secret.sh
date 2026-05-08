#!/usr/bin/env bash
set -euo pipefail

# Seal a Kubernetes secret using kubeseal and the cluster's public key
# Usage: ./seal-secret.sh <name> <namespace> --from-literal KEY=VALUE [KEY=VALUE...]

NAME="${1:-}"
NAMESPACE="${2:-}"

if [[ -z "$NAME" || -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <name> <namespace> --from-literal KEY=VALUE ..." >&2
  exit 1
fi

shift 2
LITERALS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --from-literal) LITERALS+=("$2"); shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ ${#LITERALS[@]} -eq 0 ]]; then
  echo "At least one --from-literal KEY=VALUE is required" >&2
  exit 1
fi

LITERAL_ARGS=()
for L in "${LITERALS[@]}"; do
  LITERAL_ARGS+=(--from-literal="$L")
done

echo "Creating sealed secret: $NAME in namespace $NAMESPACE"

kubectl create secret generic "$NAME" \
  --namespace "$NAMESPACE" \
  --dry-run=client \
  -o yaml \
  "${LITERAL_ARGS[@]}" \
  | kubeseal \
      --namespace "$NAMESPACE" \
      --format yaml \
      > "$(pwd)/${NAME}-sealed.yaml"

echo "Sealed secret written to: ${NAME}-sealed.yaml"
