#!/usr/bin/env bash
set -euo pipefail

# Show a Helm diff between the current release and a new chart version or values
# Usage: ./helm-diff.sh <release> <namespace> <chart> [--version <chart-version>] [--values <file>]

RELEASE="${1:-}"
NAMESPACE="${2:-}"
CHART="${3:-}"
CHART_VERSION=""
VALUES_FILE=""

if [[ -z "$RELEASE" || -z "$NAMESPACE" || -z "$CHART" ]]; then
  echo "Usage: $0 <release> <namespace> <chart> [--version <v>] [--values <file>]" >&2
  exit 1
fi

shift 3
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) CHART_VERSION="$2"; shift 2 ;;
    --values) VALUES_FILE="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if ! helm plugin list 2>/dev/null | grep -q diff; then
  echo "Installing helm-diff plugin..."
  helm plugin install https://github.com/databus23/helm-diff
fi

DIFF_ARGS=(diff upgrade "$RELEASE" "$CHART"
  --namespace "$NAMESPACE"
  --allow-unreleased
  --color
  --three-way-merge
)

if [[ -n "$CHART_VERSION" ]]; then
  DIFF_ARGS+=(--version "$CHART_VERSION")
fi

if [[ -n "$VALUES_FILE" ]]; then
  DIFF_ARGS+=(-f "$VALUES_FILE")
fi

echo "Running helm diff: $RELEASE in $NAMESPACE"
helm "${DIFF_ARGS[@]}"
