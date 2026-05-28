#!/usr/bin/env bash
set -euo pipefail

# Watch Kubernetes Warning events across namespaces and optionally stream to a log file
# Usage: ./k8s-events-watch.sh [--context <ctx>] [--namespace <ns|all>] [--log <file>] [--since <duration>]

CONTEXT=""
NAMESPACE="--all-namespaces"
LOG_FILE=""
SINCE="1h"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --context)   CONTEXT="$2";                           shift 2 ;;
    --namespace) NAMESPACE="--namespace $2";             shift 2 ;;
    --log)       LOG_FILE="$2";                          shift 2 ;;
    --since)     SINCE="$2";                             shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

KUBECTL="kubectl"
[[ -n "$CONTEXT" ]] && KUBECTL="kubectl --context $CONTEXT"

echo "=== Kubernetes Warning Events ==="
[[ "$NAMESPACE" == "--all-namespaces" ]] && echo "    Scope : all namespaces" || echo "    Scope : $NAMESPACE"
echo "    Since : $SINCE"
echo ""

snapshot() {
  $KUBECTL get events $NAMESPACE \
    --field-selector type=Warning \
    --sort-by='.lastTimestamp' \
    -o custom-columns=\
"TIME:.lastTimestamp,\
NS:.metadata.namespace,\
KIND:.involvedObject.kind,\
NAME:.involvedObject.name,\
REASON:.reason,\
MESSAGE:.message" \
    | tail -n +2
}

if [[ -n "$LOG_FILE" ]]; then
  echo "Streaming Warning events to: $LOG_FILE"
  $KUBECTL get events $NAMESPACE \
    --field-selector type=Warning \
    --watch \
    -o json 2>/dev/null \
    | jq -r '[.lastTimestamp, .metadata.namespace, .involvedObject.kind, .involvedObject.name, .reason, .message] | @tsv' \
    | tee -a "$LOG_FILE"
else
  echo "--- Recent Warning Events ---"
  snapshot | head -40

  echo ""
  echo "--- Event Counts by Reason ---"
  snapshot | awk '{print $5}' | sort | uniq -c | sort -rn | head -10
fi
