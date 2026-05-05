#!/usr/bin/env bash
set -euo pipefail

# Purge untagged and old ACR images to reduce storage costs
# Usage: ./acr-cleanup.sh <registry-name> [--days <n>] [--dry-run]

REGISTRY="${1:-}"
DAYS=30
DRY_RUN=false

if [[ -z "$REGISTRY" ]]; then
  echo "Usage: $0 <registry-name> [--days <n>] [--dry-run]" >&2
  exit 1
fi

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

CUTOFF=$(date -u -d "$DAYS days ago" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null \
  || date -u -v-"${DAYS}d" +"%Y-%m-%dT%H:%M:%SZ")

echo "Cleaning up $REGISTRY — manifests older than $DAYS days (before $CUTOFF)"

FILTER="[?lastUpdateTime < '$CUTOFF']"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] Would purge manifests matching: $FILTER"
  az acr manifest list-metadata --registry "$REGISTRY" \
    --name "$(az acr repository list --name "$REGISTRY" -o tsv | head -1)" \
    --query "$FILTER" -o table 2>/dev/null || echo "Run without --dry-run to purge"
  exit 0
fi

REPOS=$(az acr repository list --name "$REGISTRY" -o tsv)
TOTAL_PURGED=0

for REPO in $REPOS; do
  MANIFESTS=$(az acr manifest list-metadata \
    --registry "$REGISTRY" \
    --name "$REPO" \
    --query "[?lastUpdateTime < '$CUTOFF' && tags == null].digest" \
    -o tsv 2>/dev/null || true)

  for DIGEST in $MANIFESTS; do
    echo "Deleting $REPO@$DIGEST"
    az acr manifest delete --registry "$REGISTRY" --name "$REPO@$DIGEST" --yes
    TOTAL_PURGED=$((TOTAL_PURGED + 1))
  done
done

echo "Purged $TOTAL_PURGED untagged manifests older than $DAYS days."
