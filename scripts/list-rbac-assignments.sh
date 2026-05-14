#!/usr/bin/env bash
set -euo pipefail

# List all RBAC role assignments for a subscription or resource group, grouped by principal type
# Usage: ./list-rbac-assignments.sh [--scope <resource-id>] [--output <table|json|csv>]

SCOPE=""
OUTPUT_FMT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)  SCOPE="$2";      shift 2 ;;
    --output) OUTPUT_FMT="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

SCOPE_ARG=""
[[ -n "$SCOPE" ]] && SCOPE_ARG="--scope $SCOPE"

echo "=== RBAC Role Assignments ==="
[[ -n "$SCOPE" ]] && echo "    Scope: $SCOPE" || echo "    Scope: current subscription"
echo ""

ASSIGNMENTS=$(az role assignment list $SCOPE_ARG --all --include-inherited \
  --query "[].{Principal:principalName,Type:principalType,Role:roleDefinitionName,Scope:scope}" \
  -o json)

case "$OUTPUT_FMT" in
  json)
    echo "$ASSIGNMENTS" | jq .
    ;;
  csv)
    echo "Principal,Type,Role,Scope"
    echo "$ASSIGNMENTS" | jq -r '.[] | [.Principal, .Type, .Role, .Scope] | @csv'
    ;;
  table|*)
    echo "$ASSIGNMENTS" | jq -r '
      (["PRINCIPAL","TYPE","ROLE","SCOPE"] | @tsv),
      (.[] | [.Principal, .Type, .Role, (.Scope | split("/") | last)] | @tsv)
    ' | column -t
    ;;
esac

echo ""
echo "Summary by principal type:"
echo "$ASSIGNMENTS" | jq -r 'group_by(.Type)[] | "\(.[0].Type): \(length)"'
