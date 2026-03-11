#!/bin/bash
set -euo pipefail
SERVER=${1:?Usage: verify-backup.sh <server-name> <resource-group>}
RG=${2:?}
echo "Checking backup status for PostgreSQL server: $SERVER"
az postgres flexible-server backup list \
  --name "$SERVER" \
  --resource-group "$RG" \
  --query "[0:5].{name:name, createdTime:backupType, size:sizeInBytes}" \
  --output table
