#!/usr/bin/env bash
set -euo pipefail

# Trigger an on-demand Velero backup and wait for completion
# Usage: ./velero-backup.sh <backup-name> [namespace]

BACKUP_NAME="${1:-}"
NAMESPACE="${2:-}"

if [[ -z "$BACKUP_NAME" ]]; then
  echo "Usage: $0 <backup-name> [namespace]" >&2
  exit 1
fi

VELERO_ARGS=(--wait --ttl 720h0m0s)
if [[ -n "$NAMESPACE" ]]; then
  VELERO_ARGS+=(--include-namespaces "$NAMESPACE")
fi

echo "Creating backup: $BACKUP_NAME"
velero backup create "$BACKUP_NAME" "${VELERO_ARGS[@]}"

echo "Backup status:"
velero backup describe "$BACKUP_NAME" --details

PHASE=$(velero backup get "$BACKUP_NAME" -o json | jq -r '.status.phase')
if [[ "$PHASE" != "Completed" ]]; then
  echo "Backup did not complete successfully. Phase: $PHASE" >&2
  velero backup logs "$BACKUP_NAME" >&2
  exit 1
fi

echo "Backup $BACKUP_NAME completed successfully."
