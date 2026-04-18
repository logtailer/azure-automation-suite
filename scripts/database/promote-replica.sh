#!/usr/bin/env bash
set -euo pipefail

# Promote a PostgreSQL flexible server read replica to standalone (for failover)
# Usage: ./promote-replica.sh <resource-group> <replica-server-name>

RESOURCE_GROUP="${1:-}"
REPLICA_NAME="${2:-}"

if [[ -z "$RESOURCE_GROUP" || -z "$REPLICA_NAME" ]]; then
  echo "Usage: $0 <resource-group> <replica-server-name>" >&2
  exit 1
fi

echo "Promoting replica: $REPLICA_NAME in $RESOURCE_GROUP"
echo "WARNING: After promotion the replica becomes a standalone server."
echo "Update connection strings before confirming."

read -rp "Confirm promotion [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

az postgres flexible-server replica promote \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REPLICA_NAME" \
  --promote-mode standalone \
  --promote-option planned

echo "Promotion complete. Verify server state:"
az postgres flexible-server show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REPLICA_NAME" \
  --query "{name:name, state:state, replicationRole:replicationRole}" \
  -o table
