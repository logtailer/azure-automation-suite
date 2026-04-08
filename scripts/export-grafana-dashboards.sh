#!/usr/bin/env bash
set -euo pipefail

# Export all Grafana dashboards to JSON files for version control
# Usage: ./export-grafana-dashboards.sh [--host <grafana-url>] [--output-dir <dir>]

GRAFANA_HOST="${GRAFANA_HOST:-http://localhost:3000}"
OUTPUT_DIR="./grafana-dashboards"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) GRAFANA_HOST="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "${GRAFANA_TOKEN:-}" ]]; then
  echo "GRAFANA_TOKEN env var must be set" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Fetching dashboard list from $GRAFANA_HOST..."
DASHBOARDS=$(curl -sf \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  "$GRAFANA_HOST/api/search?type=dash-db&limit=500" \
  | jq -r '.[].uid')

COUNT=0
for UID in $DASHBOARDS; do
  TITLE=$(curl -sf \
    -H "Authorization: Bearer $GRAFANA_TOKEN" \
    "$GRAFANA_HOST/api/dashboards/uid/$UID" \
    | jq -r '.dashboard.title' \
    | tr ' ' '_' | tr -d '/:')

  echo "Exporting: $TITLE ($UID)"
  curl -sf \
    -H "Authorization: Bearer $GRAFANA_TOKEN" \
    "$GRAFANA_HOST/api/dashboards/uid/$UID" \
    | jq '.dashboard' \
    > "$OUTPUT_DIR/${UID}_${TITLE}.json"

  COUNT=$((COUNT + 1))
done

echo "Exported $COUNT dashboard(s) to $OUTPUT_DIR/"
