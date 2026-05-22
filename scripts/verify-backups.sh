#!/usr/bin/env bash
set -euo pipefail

# Verify Velero backups are recent and healthy
# Usage: ./verify-backups.sh [--context <kube-context>] [--max-age-hours <n>] [--namespace <ns>]

CONTEXT=""
MAX_AGE_HOURS=26
VELERO_NS="velero"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --context)       CONTEXT="$2";       shift 2 ;;
    --max-age-hours) MAX_AGE_HOURS="$2"; shift 2 ;;
    --namespace)     VELERO_NS="$2";     shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

KUBECTL="kubectl"
[[ -n "$CONTEXT" ]] && KUBECTL="kubectl --context $CONTEXT"

echo "=== Velero Backup Verification ==="
echo "    Namespace : $VELERO_NS"
echo "    Max age   : ${MAX_AGE_HOURS}h"
echo ""

BACKUPS=$($KUBECTL get backups -n "$VELERO_NS" -o json 2>/dev/null)
TOTAL=$(echo "$BACKUPS" | jq '.items | length')

if [[ "$TOTAL" -eq 0 ]]; then
  echo "ERROR: No backups found in namespace $VELERO_NS" >&2
  exit 1
fi

COMPLETED=$(echo "$BACKUPS" | jq '[.items[] | select(.status.phase == "Completed")] | length')
FAILED=$(echo "$BACKUPS" | jq '[.items[] | select(.status.phase == "Failed")] | length')
PARTIAL=$(echo "$BACKUPS" | jq '[.items[] | select(.status.phase == "PartiallyFailed")] | length')

echo "Backup counts: total=$TOTAL completed=$COMPLETED failed=$FAILED partial=$PARTIAL"
echo ""

LATEST_TIME=$(echo "$BACKUPS" | jq -r \
  '[.items[] | select(.status.phase == "Completed")] | sort_by(.status.completionTimestamp) | last | .status.completionTimestamp')

if [[ -z "$LATEST_TIME" || "$LATEST_TIME" == "null" ]]; then
  echo "ERROR: No completed backups found" >&2
  exit 1
fi

LATEST_EPOCH=$(date -d "$LATEST_TIME" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LATEST_TIME" +%s)
NOW_EPOCH=$(date +%s)
AGE_HOURS=$(( (NOW_EPOCH - LATEST_EPOCH) / 3600 ))

echo "Latest completed backup: $LATEST_TIME (${AGE_HOURS}h ago)"

if [[ "$AGE_HOURS" -gt "$MAX_AGE_HOURS" ]]; then
  echo "ERROR: Latest backup is ${AGE_HOURS}h old (threshold: ${MAX_AGE_HOURS}h)" >&2
  exit 1
fi

if [[ "$FAILED" -gt 0 ]]; then
  echo "WARNING: $FAILED backup(s) failed"
  echo "$BACKUPS" | jq -r '[.items[] | select(.status.phase == "Failed")] | .[].metadata.name'
fi

echo "Backup verification passed."
