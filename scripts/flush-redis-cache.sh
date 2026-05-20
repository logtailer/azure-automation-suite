#!/usr/bin/env bash
set -euo pipefail

# Flush one or all Redis databases on an Azure Cache for Redis instance
# Usage: ./flush-redis-cache.sh --cache <name> --rg <rg> [--db <0-15>] [--confirm]

CACHE_NAME=""
RESOURCE_GROUP=""
DB_INDEX="all"
CONFIRMED=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cache)   CACHE_NAME="$2";    shift 2 ;;
    --rg)      RESOURCE_GROUP="$2"; shift 2 ;;
    --db)      DB_INDEX="$2";       shift 2 ;;
    --confirm) CONFIRMED=true;      shift   ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$CACHE_NAME"     ]] && { echo "ERROR: --cache required" >&2; exit 1; }
[[ -z "$RESOURCE_GROUP" ]] && { echo "ERROR: --rg required"    >&2; exit 1; }

echo "=== Redis Cache Flush ==="
echo "    Cache         : $CACHE_NAME"
echo "    Resource group: $RESOURCE_GROUP"
echo "    DB / databases: $DB_INDEX"
echo ""

if [[ "$CONFIRMED" != "true" ]]; then
  read -rp "This will FLUSH data from Redis. Type 'yes' to continue: " REPLY
  [[ "$REPLY" != "yes" ]] && { echo "Aborted." ; exit 0; }
fi

HOSTNAME=$(az redis show \
  --name "$CACHE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "hostName" -o tsv)

ACCESS_KEY=$(az redis list-keys \
  --name "$CACHE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "primaryKey" -o tsv)

if [[ "$DB_INDEX" == "all" ]]; then
  redis-cli -h "$HOSTNAME" -a "$ACCESS_KEY" --tls FLUSHALL ASYNC
  echo "All databases flushed on $HOSTNAME"
else
  redis-cli -h "$HOSTNAME" -a "$ACCESS_KEY" --tls -n "$DB_INDEX" FLUSHDB ASYNC
  echo "Database $DB_INDEX flushed on $HOSTNAME"
fi
