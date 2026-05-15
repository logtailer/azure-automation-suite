#!/usr/bin/env bash
set -euo pipefail

# Export all Key Vault secrets to an encrypted local backup file
# Usage: ./backup-keyvault-secrets.sh --vault <kv-name> --output <file.enc> [--key <gpg-key-id>]

VAULT=""
OUTPUT_FILE=""
GPG_KEY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)  VAULT="$2";       shift 2 ;;
    --output) OUTPUT_FILE="$2"; shift 2 ;;
    --key)    GPG_KEY="$2";     shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$VAULT"       ]] && { echo "ERROR: --vault required"  >&2; exit 1; }
[[ -z "$OUTPUT_FILE" ]] && { echo "ERROR: --output required" >&2; exit 1; }

TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "$TMPDIR_WORK"' EXIT

echo "=== Key Vault Backup: $VAULT ==="

SECRET_NAMES=$(az keyvault secret list --vault-name "$VAULT" --query "[].name" -o tsv)
COUNT=0

for NAME in $SECRET_NAMES; do
  VALUE=$(az keyvault secret show --vault-name "$VAULT" --name "$NAME" \
    --query "value" -o tsv 2>/dev/null || echo "[ACCESS_DENIED]")
  ENABLED=$(az keyvault secret show --vault-name "$VAULT" --name "$NAME" \
    --query "attributes.enabled" -o tsv 2>/dev/null || echo "unknown")
  echo "${NAME}=${VALUE}" >> "${TMPDIR_WORK}/secrets.env"
  echo "  Backed up: $NAME (enabled=$ENABLED)"
  ((COUNT++))
done

if [[ -n "$GPG_KEY" ]]; then
  gpg --recipient "$GPG_KEY" --encrypt --output "$OUTPUT_FILE" "${TMPDIR_WORK}/secrets.env"
  echo ""
  echo "Encrypted backup written to: $OUTPUT_FILE (GPG key: $GPG_KEY)"
else
  cp "${TMPDIR_WORK}/secrets.env" "$OUTPUT_FILE"
  chmod 600 "$OUTPUT_FILE"
  echo ""
  echo "WARNING: Backup written unencrypted to $OUTPUT_FILE — secure this file!"
fi

echo "Total secrets backed up: $COUNT"
