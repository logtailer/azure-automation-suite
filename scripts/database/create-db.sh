#!/bin/bash
set -euo pipefail
SERVER=${1:?Usage: create-db.sh <server> <rg> <db-name>}
RG=${2:?}
DB=${3:?}
echo "Creating database '$DB' on server '$SERVER'..."
az postgres flexible-server db create \
  --server-name "$SERVER" \
  --resource-group "$RG" \
  --database-name "$DB"
echo "Database created."
