#!/usr/bin/env bash
set -euo pipefail

# Delete untagged manifests and images older than DAYS from an ACR repository
# Usage: ./cleanup-old-images.sh --registry <acr-name> --repo <repo-name> [--days <n>] [--dry-run]

REGISTRY=""
REPO=""
DAYS=30
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --registry) REGISTRY="$2"; shift 2 ;;
    --repo)     REPO="$2";     shift 2 ;;
    --days)     DAYS="$2";     shift 2 ;;
    --dry-run)  DRY_RUN=true;  shift   ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$REGISTRY" ]] && { echo "ERROR: --registry required" >&2; exit 1; }
[[ -z "$REPO"     ]] && { echo "ERROR: --repo required"     >&2; exit 1; }

CUTOFF=$(date -u -d "-${DAYS} days" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
        || date -u -v-"${DAYS}"d +%Y-%m-%dT%H:%M:%SZ)

echo "=== ACR Cleanup: ${REGISTRY}.azurecr.io/${REPO} ==="
echo "    Cutoff date : ${CUTOFF}"
echo "    Dry run     : ${DRY_RUN}"
echo ""

# List untagged manifests
UNTAGGED=$(az acr manifest list-metadata \
  --registry "$REGISTRY" \
  --name "$REPO" \
  --query "[?tags==null].digest" \
  -o tsv)

DELETED=0
for DIGEST in $UNTAGGED; do
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY-RUN] Would delete untagged manifest: $DIGEST"
  else
    az acr repository delete \
      --name "$REGISTRY" \
      --image "${REPO}@${DIGEST}" \
      --yes --quiet
    echo "Deleted untagged: $DIGEST"
    ((DELETED++))
  fi
done

# List old tagged images
OLD_TAGS=$(az acr repository show-tags \
  --name "$REGISTRY" \
  --repository "$REPO" \
  --detail \
  --query "[?lastUpdateTime<'${CUTOFF}'].name" \
  -o tsv)

for TAG in $OLD_TAGS; do
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY-RUN] Would delete old tag: ${REPO}:${TAG}"
  else
    az acr repository delete \
      --name "$REGISTRY" \
      --image "${REPO}:${TAG}" \
      --yes --quiet
    echo "Deleted old tag: ${REPO}:${TAG}"
    ((DELETED++))
  fi
done

echo ""
echo "Done. Manifests/tags removed: ${DELETED}"
