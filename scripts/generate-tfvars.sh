#!/usr/bin/env bash
set -euo pipefail

# Generate .tfvars files for a new environment by interpolating a template
# Usage: ./generate-tfvars.sh <module> <environment> [--subscription <id>]

MODULE="${1:-}"
ENV="${2:-}"
SUBSCRIPTION=""

if [[ -z "$MODULE" || -z "$ENV" ]]; then
  echo "Usage: $0 <module> <environment> [--subscription <id>]" >&2
  exit 1
fi

shift 2
while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription) SUBSCRIPTION="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

MODULE_DIR="terraform/$MODULE"
TEMPLATE="$MODULE_DIR/environments/template.tfvars"
OUTPUT="$MODULE_DIR/environments/$ENV.tfvars"

if [[ ! -d "$MODULE_DIR" ]]; then
  echo "Module directory not found: $MODULE_DIR" >&2
  exit 1
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE — copying from dev.tfvars as fallback"
  TEMPLATE="$MODULE_DIR/dev.tfvars"
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "No template or dev.tfvars found in $MODULE_DIR" >&2
  exit 1
fi

SUB_ID="${SUBSCRIPTION:-$(az account show --query id -o tsv 2>/dev/null || echo 'SUBSCRIPTION_ID')}"

sed \
  -e "s/{{environment}}/$ENV/g" \
  -e "s/{{subscription_id}}/$SUB_ID/g" \
  "$TEMPLATE" > "$OUTPUT"

echo "Generated: $OUTPUT"
cat "$OUTPUT"
