#!/usr/bin/env bash
set -euo pipefail

# Check TLS certificate expiry for Key Vault certificates and public endpoints
# Usage: ./check-certificate-expiry.sh [--vault <kv-name>] [--hosts <h1,h2>] [--warn-days <n>]

VAULT=""
HOSTS=""
WARN_DAYS=30
EXIT_CODE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)     VAULT="$2";     shift 2 ;;
    --hosts)     HOSTS="$2";     shift 2 ;;
    --warn-days) WARN_DAYS="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

NOW_EPOCH=$(date +%s)
WARN_EPOCH=$(( NOW_EPOCH + WARN_DAYS * 86400 ))

echo "=== TLS Certificate Expiry Check ==="
echo "    Warning threshold: ${WARN_DAYS} days"
echo ""

check_expiry() {
  local NAME="$1"
  local EXPIRY_STR="$2"
  local EXPIRY_EPOCH
  EXPIRY_EPOCH=$(date -d "$EXPIRY_STR" +%s 2>/dev/null \
               || date -j -f "%Y-%m-%dT%H:%M:%S" "${EXPIRY_STR%%.*}" +%s 2>/dev/null || echo 0)
  local DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

  if [[ "$EXPIRY_EPOCH" -lt "$NOW_EPOCH" ]]; then
    echo "  [EXPIRED ] $NAME — expired $((-DAYS_LEFT)) days ago"
    EXIT_CODE=1
  elif [[ "$EXPIRY_EPOCH" -lt "$WARN_EPOCH" ]]; then
    echo "  [WARNING ] $NAME — expires in ${DAYS_LEFT} days (${EXPIRY_STR%%T*})"
    EXIT_CODE=1
  else
    echo "  [OK      ] $NAME — expires in ${DAYS_LEFT} days (${EXPIRY_STR%%T*})"
  fi
}

if [[ -n "$VAULT" ]]; then
  echo "--- Key Vault Certificates: $VAULT ---"
  CERTS=$(az keyvault certificate list --vault-name "$VAULT" \
    --query "[].{Name:name,Expires:attributes.expires}" -o json 2>/dev/null || echo "[]")
  COUNT=$(echo "$CERTS" | jq 'length')
  if [[ "$COUNT" -eq 0 ]]; then
    echo "  No certificates found"
  else
    while IFS=$'\t' read -r NAME EXPIRY; do
      check_expiry "$NAME" "$EXPIRY"
    done < <(echo "$CERTS" | jq -r '.[] | [.Name, .Expires] | @tsv')
  fi
  echo ""
fi

if [[ -n "$HOSTS" ]]; then
  echo "--- Public Endpoint Certificates ---"
  IFS=',' read -ra HOST_LIST <<< "$HOSTS"
  for HOST in "${HOST_LIST[@]}"; do
    HOST="${HOST// /}"
    EXPIRY_STR=$(echo | openssl s_client -connect "${HOST}:443" -servername "$HOST" 2>/dev/null \
      | openssl x509 -noout -enddate 2>/dev/null \
      | cut -d= -f2 || echo "")
    if [[ -z "$EXPIRY_STR" ]]; then
      echo "  [UNKNOWN ] $HOST — could not retrieve certificate"
    else
      EXPIRY_EPOCH=$(date -d "$EXPIRY_STR" +%s 2>/dev/null || echo 0)
      check_expiry "$HOST" "$(date -d "$EXPIRY_STR" +%Y-%m-%dT%H:%M:%S 2>/dev/null || echo "$EXPIRY_STR")"
    fi
  done
fi

echo ""
[[ "$EXIT_CODE" -eq 0 ]] && echo "All certificates OK." || echo "Action required: certificates expiring soon or expired."
exit $EXIT_CODE
