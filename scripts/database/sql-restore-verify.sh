#!/bin/bash
set -euo pipefail
# Restores an Azure SQL database to a temporary validation copy and verifies it reaches Online state

SQL_SERVER="${1:?Usage: sql-restore-verify.sh <server> <resource-group> <source-db> <restore-point>}"
RG="${2:?}"
SOURCE_DB="${3:?}"
RESTORE_POINT="${4:?ISO8601 datetime, e.g. 2026-05-28T02:00:00Z}"
VERIFY_DB="restore-verify-$(date +%s)"

echo "Restoring $SOURCE_DB → $VERIFY_DB at $RESTORE_POINT..."
az sql db restore \
  --resource-group "$RG" \
  --server "$SQL_SERVER" \
  --name "$VERIFY_DB" \
  --source-database "$SOURCE_DB" \
  --time "$RESTORE_POINT" \
  --output none

echo "Polling restore status (max 15 min)..."
STATUS="Unknown"
for i in $(seq 1 60); do
  STATUS=$(az sql db show \
    --resource-group "$RG" \
    --server "$SQL_SERVER" \
    --name "$VERIFY_DB" \
    --query "status" --output tsv 2>/dev/null || echo "Unknown")
  printf "  [%02d/60] %s\n" "$i" "$STATUS"
  [[ "$STATUS" == "Online" ]] && break
  sleep 15
done

if [[ "$STATUS" != "Online" ]]; then
  echo "ERROR: Restore did not reach Online state within timeout" >&2
  exit 1
fi

echo "Restore verification PASSED — $VERIFY_DB is Online"

echo "Cleaning up verification database..."
az sql db delete \
  --resource-group "$RG" \
  --server "$SQL_SERVER" \
  --name "$VERIFY_DB" \
  --yes --output none
echo "Cleanup complete"
